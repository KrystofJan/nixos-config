{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sl
    asciiquarium-transparent
    nixd
    inputs.alejandra.defaultPackage.${system}
  ];
}
