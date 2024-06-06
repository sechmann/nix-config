{pkgs, ...}: {
  services.xserver.xkb.extraLayouts = {
    us-no = {
      description = "Vegar keys remapping";
      languages = ["eng"];
      symbolsFile = pkgs.writeText "us-no" ''
        default  partial alphanumeric_keys
        xkb_symbols "us-no" {
        	name[Group1]= "us-no";

        	include "us(basic)"

        	key <AC01> { [ a,          A,        aring,  Aring    ] };
        	key <AD09> { [ o,          O,        oslash, Ooblique ] };
        	key <AC11> { [ apostrophe, quotedbl, ae,     AE       ] };

        	key <CAPS> { [ Escape ] };

        	include "level3(ralt_switch)"
        };
      '';
    };
  };
}
