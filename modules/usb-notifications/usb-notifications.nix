{
  config,
  pkgs,
  lib,
  ...
}: {
  # Create a script that will be called by udev rules
  environment.systemPackages = with pkgs; [
    libnotify  # Required for notify-send
    (writeShellScriptBin "usb-notify" ''
      #!/bin/bash

      # Get the action (add/remove)
      ACTION="$1"
      DEVICE="$2"
      VENDOR="$3"
      MODEL="$4"
      SIZE="$5"

      # Log for debugging
      echo "$(date): USB $ACTION - Device: $DEVICE, Vendor: $VENDOR, Model: $MODEL, Size: $SIZE" >> /tmp/usb-notifications.log

      # Function to send notification to user
      send_notification() {
        local title="$1"
        local message="$2"
        local icon="$3"
        local urgency="$4"

        # Find the user's session
        USER_ID=$(id -u zahry)

        # Send notification as the user
        sudo -u zahry DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus" \
          notify-send \
          --urgency="$urgency" \
          --icon="$icon" \
          --app-name="USB Monitor" \
          --expire-time=5000 \
          "$title" \
          "$message" 2>/dev/null || true
      }

      # Clean up vendor and model names
      clean_name() {
        echo "$1" | sed 's/_/ /g' | sed 's/\\x20/ /g' | tr -d '\n'
      }

      case "$ACTION" in
        "add")
          # Clean up the names
          CLEAN_VENDOR=$(clean_name "$VENDOR")
          CLEAN_MODEL=$(clean_name "$MODEL")

          if [ -n "$CLEAN_VENDOR" ] && [ -n "$CLEAN_MODEL" ]; then
            DEVICE_NAME="$CLEAN_VENDOR $CLEAN_MODEL"
          elif [ -n "$CLEAN_VENDOR" ]; then
            DEVICE_NAME="$CLEAN_VENDOR Device"
          elif [ -n "$CLEAN_MODEL" ]; then
            DEVICE_NAME="$CLEAN_MODEL"
          else
            DEVICE_NAME="USB Storage Device"
          fi

          if [ -n "$SIZE" ] && [ "$SIZE" != "Unknown" ]; then
            MESSAGE="$DEVICE_NAME ($SIZE) has been connected"
          else
            MESSAGE="$DEVICE_NAME has been connected"
          fi

          send_notification "USB Device Connected" "$MESSAGE" "drive-removable-media" "normal"
          ;;
        "remove")
          # Clean up the names
          CLEAN_VENDOR=$(clean_name "$VENDOR")
          CLEAN_MODEL=$(clean_name "$MODEL")

          if [ -n "$CLEAN_VENDOR" ] && [ -n "$CLEAN_MODEL" ]; then
            DEVICE_NAME="$CLEAN_VENDOR $CLEAN_MODEL"
          elif [ -n "$CLEAN_VENDOR" ]; then
            DEVICE_NAME="$CLEAN_VENDOR Device"
          elif [ -n "$CLEAN_MODEL" ]; then
            DEVICE_NAME="$CLEAN_MODEL"
          else
            DEVICE_NAME="USB Storage Device"
          fi

          MESSAGE="$DEVICE_NAME has been disconnected"
          send_notification "USB Device Disconnected" "$MESSAGE" "drive-removable-media" "normal"
          ;;
      esac
    '')
  ];

  # Add simple udev rules for USB storage device notifications
  services.udev.extraRules = ''
    # USB storage device connected - block devices
    SUBSYSTEM=="block", KERNEL=="sd[a-z][0-9]", ACTION=="add", ATTRS{removable}=="1", RUN+="/run/current-system/sw/bin/usb-notify add %k Unknown Unknown Unknown"

    # USB storage device disconnected - block devices
    SUBSYSTEM=="block", KERNEL=="sd[a-z][0-9]", ACTION=="remove", ATTRS{removable}=="1", RUN+="/run/current-system/sw/bin/usb-notify remove %k Unknown Unknown ''"
  '';

  # Enable udisks2 service for better USB device management
  services.udisks2.enable = true;

  # Ensure the user is in the required groups for device access
  users.users.zahry.extraGroups = [ "disk" "storage" ];
}
