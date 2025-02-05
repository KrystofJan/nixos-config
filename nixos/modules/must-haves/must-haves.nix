{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    sl
    asciiquarium-transparent
  ];
}
