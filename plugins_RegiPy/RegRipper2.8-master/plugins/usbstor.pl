#-----------------------------------------------------------
# usbstor
#
# History:
#   20141111 - updated check for key LastWrite times
#		20141015 - added subkey LastWrite times
#   20130630 - added FirstInstallDate, InstallDate query
#   20080418 - created
#
# Ref:
#   http://studioshorts.com/blog/2012/10/windows-8-device-property-ids-device-enumeration-pnpobject/
#
# copyright 2014 QAR, LLC
# Author: H. Carvey, keydet89@yahoo.com
#-----------------------------------------------------------

package usbstor;

##Mode de compilation (oblige les variables a etre declarees)
use strict;

#My : Déclaration de variable
#( x => y ) Table de hashage
# % au début d'une variable de tableau de hash
my %config = (hive          => "System",
              osmask        => 22,
              hasShortDescr => 1,
              hasDescr      => 0,
              hasRefs       => 0,
              version       => 20141111);


#sub : declaration de fonction
sub getConfig{return %config}


sub getShortDescr {
	return "Get USBStor key info";
}

sub getDescr{}
sub getRefs {}
sub getHive {return $config{hive};}
sub getVersion {return $config{version};}

my $VERSION = getVersion();

sub pluginmain {
#shift : prends la premiere valeur de @argv
	my $class = shift;
	my $hive = shift;

#Affichage
#logMsg : Ecriture dans le fichier de log
	::logMsg("Launching usbstor v.".$VERSION);
	::rptMsg("usbstor v.".$VERSION); # banner
	::rptMsg("(".getHive().") ".getShortDescr()."\n"); # banner

 #Analyse le registre windows
 #Création d'une instance de la classe Win32Registry
	my $reg = Parse::Win32Registry->new($hive); # Renvoi un hash

	#Récupération de la clé racine
	my $root_key = $reg->get_root_key;

# Code for System file, getting CurrentControlSet
	my $current;
	my $ccs;
	my $key_path = 'Select';
	my $key;

  ::rptMsg("INITIALISATION DES VARIABLES");
	::rptMsg("key init : ".$key); # NULL
  ::rptMsg("root key : ".$root_key); #Parse::Win32Registry::WinNT::Key=HASH(0x658de2c)
  ::rptMsg("ccs : ".$ccs); #NULL
  ::rptMsg("current : ".$current); #NULL
  ::rptMsg("key_path : ".$key_path."\n"); # "Select"


	if ($key = $root_key->get_subkey($key_path)) { # PASSAGE CONFIRME DANS LE IF
    ::rptMsg("PASSAGE DANS LE IF DE LA PREMIERE CONDITION \n");
		$current = $key->get_value("Current")->get_data(); #Récupere la valeur numerique du CurrentControlSet (0 ou 1)
		$ccs = "ControlSet00".$current; #AJOUT DE LA VALEUR $current. --> $ccs = CurrentControlSet001
	}
	else {
		::rptMsg($key_path." not found.");
		return;
	}

	my $key_path = $ccs."\\Enum\\USBStor";
	my $key;


    ::rptMsg("VALEURS APRES LA PREMIERE CONDITION");
  	::rptMsg("key init : ".$key); # NULL
    ::rptMsg("root key : ".$root_key); #Parse::Win32Registry::WinNT::Key=HASH(0x658de2c)
    ::rptMsg("ccs : ".$ccs); # 1
    ::rptMsg("current : ".$current); # CurrentControlSet001
    ::rptMsg("key_path : ".$key_path."\n"); #ControlSet001\Enum\USBStor


	if ($key = $root_key->get_subkey($key_path)) {
    ::rptMsg("PASSAGE DANS LE IF DE LA DEUXIEME CONDITION \n");
		::rptMsg("USBStor");
		::rptMsg($key_path);#ControlSet001\Enum\USBStor
		::rptMsg("");

		my @subkeys = $key->get_list_of_subkeys();
		if (scalar(@subkeys) > 0) {
			foreach my $s (@subkeys) {
				::rptMsg($s->get_name()." [".gmtime($s->get_timestamp())."]");

				my @sk = $s->get_list_of_subkeys();
				if (scalar(@sk) > 0) {
					foreach my $k (@sk) {
						my $serial = $k->get_name();
						::rptMsg("  S/N: ".$serial." [".gmtime($k->get_timestamp())."]");
# added 20141015; updated 20141111
						eval {
							::rptMsg("  Device Parameters LastWrite: [".gmtime($k->get_subkey("Device Parameters")->get_timestamp())."]");
						};
						eval {
							::rptMsg("  LogConf LastWrite          : [".gmtime($k->get_subkey("LogConf")->get_timestamp())."]");
						};
						eval {
							::rptMsg("  Properties LastWrite       : [".gmtime($k->get_subkey("Properties")->get_timestamp())."]");
						};
						my $friendly;
						eval {
							$friendly = $k->get_value("FriendlyName")->get_data();
						};
						::rptMsg("    FriendlyName    : ".$friendly) if ($friendly ne "");
						my $parent;
						eval {
							$parent = $k->get_value("ParentIdPrefix")->get_data();
						};
						::rptMsg("    ParentIdPrefix: ".$parent) if ($parent ne "");
# Attempt to retrieve InstallDate/FirstInstallDate from Properties subkeys
# http://studioshorts.com/blog/2012/10/windows-8-device-property-ids-device-enumeration-pnpobject/

						eval {
							my $t = $k->get_subkey("Properties\\{83da6326-97a6-4088-9453-a1923f573b29}\\00000064\\00000000")->get_value("Data")->get_data();
							my ($t0,$t1) = unpack("VV",$t);
							::rptMsg("    InstallDate     : ".gmtime(::getTime($t0,$t1))." UTC");

							$t = $k->get_subkey("Properties\\{83da6326-97a6-4088-9453-a1923f573b29}\\00000065\\00000000")->get_value("Data")->get_data();
							($t0,$t1) = unpack("VV",$t);
							::rptMsg("    FirstInstallDate: ".gmtime(::getTime($t0,$t1))." UTC");
						};

					}
				}
				::rptMsg("");
			}
		}
		else {
			::rptMsg($key_path." has no subkeys.");
		}
	}
	else {
		::rptMsg($key_path." not found.");
	}
}
1;
