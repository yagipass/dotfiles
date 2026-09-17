_:

{
  programs.awscli = {
    enable = true;
    settings = {
      default = {
        region = "ap-northeast-1";
        output = "json";
      };
    };
  };
}
