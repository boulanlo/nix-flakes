{
  description = "Personnal flake for templates and packages";
  outputs = { self, nixpkgs }: 
  let templates = import ./templates/nix_flake_templates.nix;
  in { inherit templates; 
  };
}
