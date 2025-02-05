{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    pkgs.sl
    pkgs.asciiquarium-transparent
  ];
}
