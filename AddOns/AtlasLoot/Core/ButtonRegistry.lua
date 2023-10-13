local AL = AceLibrary("AceLocale-2.2"):new("AtlasLoot");

-- Colours stored for code readability
local GREY = "|cff999999";
local RED = "|cffff0000";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff1eff00";
local PURPLE = "|cff9F3FFF";
local BLUE = "|cff0070dd";
local ORANGE = "|cffFF8400";

AtlasLoot_ButtonRegistry = {
	--WoW Instances
    ["HQHighForemanBargulBlackhammer"] = {
        Title = AL["High Foreman Bargul Blackhammer"];
        Next_Page = "HQEngineerFiggles";
        Next_Title = AL["Engineer Figgles"];
    };
    ["HQEngineerFiggles"] = {
        Title = AL["Engineer Figgles"];
        Next_Page = "HQCorrosis";
        Next_Title = AL["Corrosis"];
        Prev_Page = "HQHighForemanBargulBlackhammer";
        Prev_Title = AL["High Foreman Bargul Blackhammer"];
    };
    ["HQCorrosis"] = {
        Title = AL["Corrosis"];
        Next_Page = "HQHatereaverAnnihilator";
        Next_Title = AL["Hatereaver Annihilator"];
        Prev_Page = "HQEngineerFiggles";
        Prev_Title = AL["Engineer Figgles"];
    };
    ["HQHatereaverAnnihilator"] = {
        Title = AL["Hatereaver Annihilator"];
        Next_Page = "HQHargeshDoomcaller";
        Next_Title = AL["Hargesh Doomcaller"];
        Prev_Page = "HQCorrosis";
        Prev_Title = AL["Corrosis"];
    };
    ["HQHargeshDoomcaller"] = {
        Title = AL["Hargesh Doomcaller"];
        Prev_Page = "HQHatereaverAnnihilator";
        Prev_Title = AL["Hatereaver Annihilator"];
    };
    ["BRDLordRoccor"] = {
        Title = AL["Lord Roccor"];
        Next_Page = "BRDHighInterrogatorGerstahn";
        Next_Title = AL["High Interrogator Gerstahn"];
    };
    ["BRDHighInterrogatorGerstahn"] = {
        Title = AL["High Interrogator Gerstahn"];
        Next_Page = "BRDAnubshiah";
        Next_Title = AL["Anub'shiah"];
        Prev_Page = "BRDLordRoccor";
        Prev_Title = AL["Lord Roccor"];
    };
    ["BRDAnubshiah"] = {
        Title = AL["Anub'shiah"];
        Next_Page = "BRDEviscerator";
        Next_Title = AL["Eviscerator"];
        Prev_Page = "BRDHighInterrogatorGerstahn";
        Prev_Title = AL["High Interrogator Gerstahn"];
    };
    ["BRDEviscerator"] = {
        Title = AL["Eviscerator"];
        Next_Page = "BRDGorosh";
        Next_Title = AL["Gorosh the Dervish"];
        Prev_Page = "BRDAnubshiah";
        Prev_Title = AL["Anub'shiah"];
    };
    ["BRDGorosh"] = {
        Title = AL["Gorosh the Dervish"];
        Next_Page = "BRDGrizzle";
        Next_Title = AL["Grizzle"];
        Prev_Page = "BRDEviscerator";
        Prev_Title = AL["Eviscerator"];
    };
    ["BRDGrizzle"] = {
        Title = AL["Grizzle"];
        Next_Page = "BRDHedrum";
        Next_Title = AL["Hedrum the Creeper"];
        Prev_Page = "BRDGorosh";
        Prev_Title = AL["Gorosh the Dervish"];
    };
    ["BRDHedrum"] = {
        Title = AL["Hedrum the Creeper"];
        Next_Page = "BRDOkthor";
        Next_Title = AL["Ok'thor the Breaker"];
        Prev_Page = "BRDGrizzle";
        Prev_Title = AL["Grizzle"];
    };
    ["BRDOkthor"] = {
        Title = AL["Ok'thor the Breaker"];
        Next_Page = "BRDTheldren";
        Next_Title = AL["Theldren"];
        Prev_Page = "BRDHedrum";
        Prev_Title = AL["Hedrum the Creeper"];
    };
    ["BRDTheldren"] = {
        Title = AL["Theldren"];
        Next_Page = "BRDHoundmaster";
        Next_Title = AL["Houndmaster Grebmar"];
        Prev_Page = "BRDOkthor";
        Prev_Title = AL["Ok'thor the Breaker"];
    };
    ["BRDHoundmaster"] = {
        Title = AL["Houndmaster Grebmar"];
        Next_Page = "BRDPyromancerLoregrain";
        Next_Title = AL["Pyromancer Loregrain"].." ("..AL["Rare"]..")";
        Prev_Page = "BRDTheldren";
        Prev_Title = AL["Theldren"];
    };
    ["BRDPyromancerLoregrain"] = {
        Title = AL["Pyromancer Loregrain"].." ("..AL["Rare"]..")";
        Next_Page = "BRDTheVault";
        Next_Title = AL["The Vault"];
        Prev_Page = "BRDHoundmaster";
        Prev_Title = AL["Houndmaster Grebmar"];
    };
    ["BRDTheVault"] = {
        Title = AL["The Vault"];
        Next_Page = "BRDWarderStilgiss";
        Next_Title = AL["Warder Stilgiss"].." ("..AL["Rare"]..")";
        Prev_Page = "BRDPyromancerLoregrain";
        Prev_Title = AL["Pyromancer Loregrain"].." ("..AL["Rare"]..")";
    };
    ["BRDWarderStilgiss"] = {
        Title = AL["Warder Stilgiss"].." ("..AL["Rare"]..")";
        Next_Page = "BRDVerek";
        Next_Title = AL["Verek"].." ("..AL["Rare"]..")";
        Prev_Page = "BRDTheVault";
        Prev_Title = AL["The Vault"];
    };
    ["BRDVerek"] = {
        Title = AL["Verek"].." ("..AL["Rare"]..")";
        Next_Page = "BRDFineousDarkvire";
        Next_Title = AL["Fineous Darkvire"];
        Prev_Page = "BRDWarderStilgiss";
        Prev_Title = AL["Warder Stilgiss"].." ("..AL["Rare"]..")";
    };
    ["BRDFineousDarkvire"] = {
        Title = AL["Fineous Darkvire"];
        Next_Page = "BRDLordIncendius";
        Next_Title = AL["Lord Incendius"];
        Prev_Page = "BRDVerek";
        Prev_Title = AL["Verek"].." ("..AL["Rare"]..")";
    };
    ["BRDLordIncendius"] = {
        Title = AL["Lord Incendius"];
        Next_Page = "BRDBaelGar";
        Next_Title = AL["Bael'Gar"];
        Prev_Page = "BRDFineousDarkvire";
        Prev_Title = AL["Fineous Darkvire"];
    };
    ["BRDBaelGar"] = {
        Title = AL["Bael'Gar"];
        Next_Page = "BRDGeneralAngerforge";
        Next_Title = AL["General Angerforge"];
        Prev_Page = "BRDLordIncendius";
        Prev_Title = AL["Lord Incendius"];
    };
    ["BRDGeneralAngerforge"] = {
        Title = AL["General Angerforge"];
        Next_Page = "BRDGolemLordArgelmach";
        Next_Title = AL["Golem Lord Argelmach"];
        Prev_Page = "BRDBaelGar";
        Prev_Title = AL["Bael'Gar"];
    };
    ["BRDGolemLordArgelmach"] = {
        Title = AL["Golem Lord Argelmach"];
        Next_Page = "BRDGuzzler";
        Next_Title = AL["The Grim Guzzler"];
        Prev_Page = "BRDGeneralAngerforge";
        Prev_Title = AL["General Angerforge"];
    };
    ["BRDGuzzler"] = {
        Title = AL["The Grim Guzzler"];
        Next_Page = "BRDFlamelash";
        Next_Title = AL["Ambassador Flamelash"];
        Prev_Page = "BRDGolemLordArgelmach";
        Prev_Title = AL["Golem Lord Argelmach"];
    };
    ["BRDFlamelash"] = {
        Title = AL["Ambassador Flamelash"];
        Next_Page = "BRDPanzor";
        Next_Title = AL["Panzor the Invincible"].." ("..AL["Rare"]..")";
        Prev_Page = "BRDGuzzler";
        Prev_Title = AL["The Grim Guzzler"];
    };
    ["BRDPanzor"] = {
        Title = AL["Panzor the Invincible"].." ("..AL["Rare"]..")";
        Next_Page = "BRDTomb";
        Next_Title = AL["Summoner's Tomb"];
        Prev_Page = "BRDFlamelash";
        Prev_Title = AL["Ambassador Flamelash"];
    };
    ["BRDTomb"] = {
        Title = AL["Summoner's Tomb"];
        Next_Page = "BRDMagmus";
        Next_Title = AL["Magmus"];
        Prev_Page = "BRDPanzor";
        Prev_Title = AL["Panzor the Invincible"].." ("..AL["Rare"]..")";
    };
    ["BRDMagmus"] = {
        Title = AL["Magmus"];
        Next_Page = "BRDPrincess";
        Next_Title = AL["Princess Moira Bronzebeard"];
        Prev_Page = "BRDTomb";
        Prev_Title = AL["Summoner's Tomb"];
    };
    ["BRDPrincess"] = {
        Title = AL["Princess Moira Bronzebeard"];
        Next_Page = "BRDEmperorDagranThaurissan";
        Next_Title = AL["Emperor Dagran Thaurissan"];
        Prev_Page = "BRDMagmus";
        Prev_Title = AL["Magmus"];
    };
    ["BRDEmperorDagranThaurissan"] = {
        Title = AL["Emperor Dagran Thaurissan"];
        Next_Page = "BRDTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "BRDPrincess";
        Prev_Title = AL["Princess Moira Bronzebeard"];
    };
    ["BRDTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "BRDEmperorDagranThaurissan";
        Prev_Title = AL["Emperor Dagran Thaurissan"];
    };
    ["LBRSSpirestoneButcher"] = {
        Title = AL["Spirestone Butcher"].." ("..AL["Rare"]..")";
        Next_Page = "LBRSSpirestoneBattleLord";
        Next_Title = AL["Spirestone Battle Lord"].." ("..AL["Rare"]..")";
    };
    ["LBRSSpirestoneBattleLord"] = {
        Title = AL["Spirestone Battle Lord"].." ("..AL["Rare"]..")";
        Next_Page = "LBRSSpirestoneLordMagus";
        Next_Title = AL["Spirestone Lord Magus"].." ("..AL["Rare"]..")";
        Prev_Page = "LBRSSpirestoneButcher";
        Prev_Title = AL["Spirestone Butcher"].." ("..AL["Rare"]..")";
    };
    ["LBRSSpirestoneLordMagus"] = {
        Title = AL["Spirestone Lord Magus"].." ("..AL["Rare"]..")";
        Next_Page = "LBRSOmokk";
        Next_Title = AL["Highlord Omokk"];
        Prev_Page = "LBRSSpirestoneBattleLord";
        Prev_Title = AL["Spirestone Battle Lord"].." ("..AL["Rare"]..")";
    };
    ["LBRSOmokk"] = {
        Title = AL["Highlord Omokk"];
        Next_Page = "LBRSVosh";
        Next_Title = AL["Shadow Hunter Vosh'gajin"];
        Prev_Page = "LBRSSpirestoneLordMagus";
        Prev_Title = AL["Spirestone Lord Magus"].." ("..AL["Rare"]..")";
    };
    ["LBRSVosh"] = {
        Title = AL["Shadow Hunter Vosh'gajin"];
        Next_Page = "LBRSVoone";
        Next_Title = AL["War Master Voone"];
        Prev_Page = "LBRSOmokk";
        Prev_Title = AL["Highlord Omokk"];
    };
    ["LBRSVoone"] = {
        Title = AL["War Master Voone"];
        Next_Page = "LBRSFelguard";
        Next_Title = AL["Burning Felguard"].." ("..AL["Rare"]..")";
        Prev_Page = "LBRSVosh";
        Prev_Title = AL["Shadow Hunter Vosh'gajin"];
    };
    ["LBRSFelguard"] = {
        Title = AL["Burning Felguard"].." ("..AL["Rare"]..")";
        Next_Page = "LBRSGrayhoof";
        Next_Title = AL["Mor Grayhoof"];
        Prev_Page = "LBRSVoone";
        Prev_Title = AL["War Master Voone"];
    };
    ["LBRSGrayhoof"] = {
        Title = AL["Mor Grayhoof"];
        Next_Page = "LBRSGrimaxe";
        Next_Title = AL["Bannok Grimaxe"].." ("..AL["Rare"]..")";
        Prev_Page = "LBRSFelguard";
        Prev_Title = AL["Burning Felguard"].." ("..AL["Rare"]..")";
    };
    ["LBRSGrimaxe"] = {
        Title = AL["Bannok Grimaxe"].." ("..AL["Rare"]..")";
        Next_Page = "LBRSSmolderweb";
        Next_Title = AL["Mother Smolderweb"];
        Prev_Page = "LBRSGrayhoof";
        Prev_Title = AL["Mor Grayhoof"];
    };
    ["LBRSSmolderweb"] = {
        Title = AL["Mother Smolderweb"];
        Next_Page = "LBRSCrystalFang";
        Next_Title = AL["Crystal Fang"].." ("..AL["Rare"]..")";
        Prev_Page = "LBRSGrimaxe";
        Prev_Title = AL["Bannok Grimaxe"].." ("..AL["Rare"]..")";
    };
    ["LBRSCrystalFang"] = {
        Title = AL["Crystal Fang"].." ("..AL["Rare"]..")";
        Next_Page = "LBRSDoomhowl";
        Next_Title = AL["Urok Doomhowl"];
        Prev_Page = "LBRSSmolderweb";
        Prev_Title = AL["Mother Smolderweb"];
    };
    ["LBRSDoomhowl"] = {
        Title = AL["Urok Doomhowl"];
        Next_Page = "LBRSZigris";
        Next_Title = AL["Quartermaster Zigris"];
        Prev_Page = "LBRSCrystalFang";
        Prev_Title = AL["Crystal Fang"].." ("..AL["Rare"]..")";
    };
    ["LBRSZigris"] = {
        Title = AL["Quartermaster Zigris"];
        Next_Page = "LBRSHalycon";
        Next_Title = AL["Halycon"];
        Prev_Page = "LBRSDoomhowl";
        Prev_Title = AL["Urok Doomhowl"];
    };
    ["LBRSHalycon"] = {
        Title = AL["Halycon"];
        Next_Page = "LBRSSlavener";
        Next_Title = AL["Gizrul the Slavener"];
        Prev_Page = "LBRSZigris";
        Prev_Title = AL["Quartermaster Zigris"];
    };
    ["LBRSSlavener"] = {
        Title = AL["Gizrul the Slavener"];
        Next_Page = "LBRSBashguud";
        Next_Title = AL["Ghok Bashguud"].." ("..AL["Rare"]..")";
        Prev_Page = "LBRSHalycon";
        Prev_Title = AL["Halycon"];
    };
    ["LBRSBashguud"] = {
        Title = AL["Ghok Bashguud"].." ("..AL["Rare"]..")";
        Next_Page = "LBRSWyrmthalak";
        Next_Title = AL["Overlord Wyrmthalak"];
        Prev_Page = "LBRSSlavener";
        Prev_Title = AL["Gizrul the Slavener"];
    };
    ["LBRSWyrmthalak"] = {
        Title = AL["Overlord Wyrmthalak"];
        Next_Page = "LBRSTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "LBRSBashguud";
        Prev_Title = AL["Ghok Bashguud"].." ("..AL["Rare"]..")";
    };
    ["LBRSTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "LBRSWyrmthalak";
        Prev_Title = AL["Overlord Wyrmthalak"];
    };
    ["UBRSEmberseer"] = {
        Title = AL["Pyroguard Emberseer"];
        Next_Page = "UBRSSolakar";
        Next_Title = AL["Solakar Flamewreath"];
    };
    ["UBRSSolakar"] = {
        Title = AL["Solakar Flamewreath"];
        Next_Page = "UBRSFlame";
        Next_Title = AL["Father Flame"];
        Prev_Page = "UBRSEmberseer";
        Prev_Title = AL["Pyroguard Emberseer"];
    };
    ["UBRSFlame"] = {
        Title = AL["Father Flame"];
        Next_Page = "UBRSRunewatcher";
        Next_Title = AL["Jed Runewatcher"].." ("..AL["Rare"]..")";
        Prev_Page = "UBRSSolakar";
        Prev_Title = AL["Solakar Flamewreath"];
    };
    ["UBRSRunewatcher"] = {
        Title = AL["Jed Runewatcher"].." ("..AL["Rare"]..")";
        Next_Page = "UBRSAnvilcrack";
        Next_Title = AL["Goraluk Anvilcrack"].." ("..AL["Rare"]..")";
        Prev_Page = "UBRSFlame";
        Prev_Title = AL["Father Flame"];
    };
    ["UBRSAnvilcrack"] = {
        Title = AL["Goraluk Anvilcrack"].." ("..AL["Rare"]..")";
        Next_Page = "UBRSRend";
        Next_Title = AL["Warchief Rend Blackhand"];
        Prev_Page = "UBRSRunewatcher";
        Prev_Title = AL["Jed Runewatcher"].." ("..AL["Rare"]..")";
    };
    ["UBRSRend"] = {
        Title = AL["Warchief Rend Blackhand"];
        Next_Page = "UBRSGyth";
        Next_Title = AL["Gyth"];
        Prev_Page = "UBRSAnvilcrack";
        Prev_Title = AL["Goraluk Anvilcrack"].." ("..AL["Rare"]..")";
    };
    ["UBRSGyth"] = {
        Title = AL["Gyth"];
        Next_Page = "UBRSBeast";
        Next_Title = AL["The Beast"];
        Prev_Page = "UBRSRend";
        Prev_Title = AL["Warchief Rend Blackhand"];
    };
    ["UBRSBeast"] = {
        Title = AL["The Beast"];
        Next_Page = "UBRSValthalak";
        Next_Title = AL["Lord Valthalak"];
        Prev_Page = "UBRSGyth";
        Prev_Title = AL["Gyth"];
    };
    ["UBRSValthalak"] = {
        Title = AL["Lord Valthalak"];
        Next_Page = "UBRSDrakkisath";
        Next_Title = AL["General Drakkisath"];
        Prev_Page = "UBRSBeast";
        Prev_Title = AL["The Beast"];
    };
    ["UBRSDrakkisath"] = {
        Title = AL["General Drakkisath"];
        Next_Page = "UBRSTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "UBRSValthalak";
        Prev_Title = AL["Lord Valthalak"];
    };
    ["UBRSTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "UBRSDrakkisath";
        Prev_Title = AL["General Drakkisath"];
    };
    ["KCMarrowspike"] = {
        Title = AL["Marrowspike"];
        Next_Page = "KCHivaxxis";
        Next_Title = AL["Hivaxxis"];
    };
    ["KCHivaxxis"] = {
        Title = AL["Hivaxxis"];
        Next_Page = "KCCorpsemuncher";
        Next_Title = AL["Corpsemuncher"];
        Prev_Page = "KCMarrowspike";
        Prev_Title = AL["Marrowspike"];
    };
    ["KCCorpsemuncher"] = {
        Title = AL["Corpsemuncher"];
        Next_Page = "KCGuardCaptainGort";
        Next_Title = AL["Guard Captain Gort"];
        Prev_Page = "KCHivaxxis";
        Prev_Title = AL["Hivaxxis"];
    };
    ["KCGuardCaptainGort"] = {
        Title = AL["Guard Captain Gort"];
        Next_Page = "KCArchlichEnkhraz";
        Next_Title = AL["Archlich Enkhraz"];
        Prev_Page = "KCCorpsemuncher";
        Prev_Title = AL["Corpsemuncher"];
    };
    ["KCArchlichEnkhraz"] = {
        Title = AL["Archlich Enkhraz"];
        Next_Page = "KCCommanderAnderson";
        Next_Title = AL["Commander Anderson"];
        Prev_Page = "KCGuardCaptainGort";
        Prev_Title = AL["Guard Captain Gort"];
    };
    ["KCCommanderAnderson"] = {
        Title = AL["Commander Anderson"];
        Next_Page = "KCAlarus";
        Next_Title = AL["Alarus"];
        Prev_Page = "KCArchlichEnkhraz";
        Prev_Title = AL["Archlich Enkhraz"];
    };
    ["KCAlarus"] = {
        Title = AL["Alarus"];
        Next_Page = "KCTreasure";
        Next_Title = AL["Half-Buried Treasure Chest"];
        Prev_Page = "KCCommanderAnderson";
        Prev_Title = AL["Commander Anderson"];
    };
	["KCTreasure"] = {
		Title = AL["Half-Buried Treasure Chest"];
        Prev_Page = "KCAlarus";
        Prev_Title = AL["Alarus"];
	};
    ["COTBMChronar"] = {
        Title = AL["Chronar"];
        Next_Page = "COTBMHarbingerAphygth";
        Next_Title = AL["Harbinger Aph'ygth"];
    };
    ["COTBMHarbingerAphygth"] = {
        Title = AL["Harbinger Aph'ygth"];
        Next_Page = "COTBMTimeLordEpochronos";
        Next_Title = AL["Time-Lord Epochronos"];
        Prev_Page = "COTBMChronar";
        Prev_Title = AL["Chronar"];
    };
    ["COTBMTimeLordEpochronos"] = {
        Title = AL["Time-Lord Epochronos"];
        Next_Page = "COTBMAntnormi";
        Next_Title = AL["Antnormi"];
        Prev_Page = "COTBMHarbingerAphygth";
        Prev_Title = AL["Harbinger Aph'ygth"];
    };
    ["COTBMAntnormi"] = {
        Title = AL["Antnormi"];
        Next_Page = "COTBMInfiniteChromie";
        Next_Title = AL["Infinite Chromie"];
        Prev_Page = "COTBMTimeLordEpochronos";
        Prev_Title = AL["Time-Lord Epochronos"];
    };
    ["COTBMInfiniteChromie"] = {
        Title = AL["Infinite Chromie"];
        Prev_Page = "COTBMAntnormi";
        Prev_Title = AL["Antnormi"];
    };
    ["SWVAszoshGrimflame"] = {
        Title = AL["Aszosh Grimflame"];
        Next_Page = "SWVThamGrarr";
        Next_Title = AL["Tham'Grarr"];
    };
    ["SWVThamGrarr"] = {
        Title = AL["Tham'Grarr"];
        Next_Page = "SWVBlackBride";
        Next_Title = AL["Black Bride"];
        Prev_Page = "SWVAszoshGrimflame";
        Prev_Title = AL["Aszosh Grimflame"];
    };
    ["SWVBlackBride"] = {
        Title = AL["Black Bride"];
        Next_Page = "SWVDamian";
        Next_Title = AL["Damian"];
        Prev_Page = "SWVThamGrarr";
        Prev_Title = AL["Tham'Grarr"];
    };
    ["SWVDamian"] = {
        Title = AL["Damian"];
        Next_Page = "SWVVolkanCruelblade";
        Next_Title = AL["Volkan Cruelblade"];
        Prev_Page = "SWVBlackBride";
        Prev_Title = AL["Black Bride"];
    };
    ["SWVVolkanCruelblade"] = {
        Title = AL["Volkan Cruelblade"];
        Next_Page = "SWVArctiras";
        Next_Title = AL["Arc'tiras"];
        Prev_Page = "SWVDamian";
        Prev_Title = AL["Damian"];
    };
    ["SWVArctiras"] = {
        Title = AL["Arc'tiras"];
        Next_Page = "SWVVaultArmoryEquipment";
        Next_Title = AL["Vault Armory Equipment"];
        Prev_Page = "SWVVolkanCruelblade";
        Prev_Title = AL["Volkan Cruelblade"];
    };
    ["SWVVaultArmoryEquipment"] = {
        Title = AL["Vault Armory Equipment"];
        Prev_Page = "SWVArctiras";
        Prev_Title = AL["Arc'tiras"];
    };
    ["BWLRazorgore"] = {
        Title = AL["Razorgore the Untamed"];
        Next_Page = "BWLVaelastrasz";
        Next_Title = AL["Vaelastrasz the Corrupt"];
    };
    ["BWLVaelastrasz"] = {
        Title = AL["Vaelastrasz the Corrupt"];
        Next_Page = "BWLLashlayer";
        Next_Title = AL["Broodlord Lashlayer"];
        Prev_Page = "BWLRazorgore";
        Prev_Title = AL["Razorgore the Untamed"];
    };
    ["BWLLashlayer"] = {
        Title = AL["Broodlord Lashlayer"];
        Next_Page = "BWLFiremaw";
        Next_Title = AL["Firemaw"];
        Prev_Page = "BWLVaelastrasz";
        Prev_Title = AL["Vaelastrasz the Corrupt"];
    };
    ["BWLFiremaw"] = {
        Title = AL["Firemaw"];
        Next_Page = "BWLEbonroc";
        Next_Title = AL["Ebonroc"];
        Prev_Page = "BWLLashlayer";
        Prev_Title = AL["Broodlord Lashlayer"];
    };
    ["BWLEbonroc"] = {
        Title = AL["Ebonroc"];
        Next_Page = "BWLFlamegor";
        Next_Title = AL["Flamegor"];
        Prev_Page = "BWLFiremaw";
        Prev_Title = AL["Firemaw"];
    };
    ["BWLFlamegor"] = {
        Title = AL["Flamegor"];
        Next_Page = "BWLChromaggus";
        Next_Title = AL["Chromaggus"];
        Prev_Page = "BWLEbonroc";
        Prev_Title = AL["Ebonroc"];
    };
    ["BWLChromaggus"] = {
        Title = AL["Chromaggus"];
        Next_Page = "BWLNefarian";
        Next_Title = AL["Nefarian"];
        Prev_Page = "BWLFlamegor";
        Prev_Title = AL["Flamegor"];
    };
    ["BWLNefarian"] = {
        Title = AL["Nefarian"];
        Next_Page = "BWLTrashMobs";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "BWLChromaggus";
        Prev_Title = AL["Chromaggus"];
    };
    ["BWLTrashMobs"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "BWLNefarian";
        Prev_Title = AL["Nefarian"];
    };
    ["DMRhahkZor"] = {
        Title = AL["Rhahk'Zor"];
        Next_Page = "DMMinerJohnson";
        Next_Title = AL["Miner Johnson"].." ("..AL["Rare"]..")";
    };
    ["DMMinerJohnson"] = {
        Title = AL["Miner Johnson"].." ("..AL["Rare"]..")";
        Next_Page = "DMSneed";
        Next_Title = AL["Sneed"];
        Prev_Page = "DMRhahkZor";
        Prev_Title = AL["Rhahk'Zor"];
    };
    ["DMSneed"] = {
        Title = AL["Sneed"];
        Next_Page = "DMSneedsShredder";
        Next_Title = AL["Sneed's Shredder"];
        Prev_Page = "DMMinerJohnson";
        Prev_Title = AL["Miner Johnson"].." ("..AL["Rare"]..")";
    };
    ["DMSneedsShredder"] = {
        Title = AL["Sneed's Shredder"];
        Next_Page = "DMGilnid";
        Next_Title = AL["Gilnid"];
        Prev_Page = "DMSneed";
        Prev_Title = AL["Sneed"];
    };
    ["DMGilnid"] = {
        Title = AL["Gilnid"];
        Next_Page = "DMMrSmite";
        Next_Title = AL["Mr. Smite"];
        Prev_Page = "DMSneedsShredder";
        Prev_Title = AL["Sneed's Shredder"];
    };
    ["DMMrSmite"] = {
        Title = AL["Mr. Smite"];
        Next_Page = "DMCookie";
        Next_Title = AL["Cookie"];
        Prev_Page = "DMGilnid";
        Prev_Title = AL["Gilnid"];
    };
    ["DMCookie"] = {
        Title = AL["Cookie"];
        Next_Page = "DMCaptainGreenskin";
        Next_Title = AL["Captain Greenskin"];
        Prev_Page = "DMMrSmite";
        Prev_Title = AL["Mr. Smite"];
    };
    ["DMCaptainGreenskin"] = {
        Title = AL["Captain Greenskin"];
        Next_Page = "DMVanCleef";
        Next_Title = AL["Edwin VanCleef"];
        Prev_Page = "DMCookie";
        Prev_Title = AL["Cookie"];
    };
    ["DMVanCleef"] = {
        Title = AL["Edwin VanCleef"];
        Next_Page = "DMTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "DMCaptainGreenskin";
        Prev_Title = AL["Captain Greenskin"];
    };
    ["DMTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "DMVanCleef";
        Prev_Title = AL["Edwin VanCleef"];
    };
    ["TCGGrovetenderEngryss"] = {
        Title = AL["Grovetender Engryss"];
        Next_Page = "TCGKeeperRanathos";
        Next_Title = AL["Keeper Ranathos"];
    };
    ["TCGKeeperRanathos"] = {
        Title = AL["Keeper Ranathos"];
        Next_Page = "TCGHighPriestessAlathea";
        Next_Title = AL["High Priestess A'lathea"];
        Prev_Page = "TCGGrovetenderEngryss";
        Prev_Title = AL["Grovetender Engryss"];
    };
    ["TCGHighPriestessAlathea"] = {
        Title = AL["High Priestess A'lathea"];
        Next_Page = "TCGFenektistheDeceiver";
        Next_Title = AL["Fenektis the Deceiver"];
        Prev_Page = "TCGKeeperRanathos";
        Prev_Title = AL["Keeper Ranathos"];
    };
    ["TCGFenektistheDeceiver"] = {
        Title = AL["Fenektis the Deceiver"];
        Next_Page = "TCGMasterRaxxieth";
        Next_Title = AL["Master Raxxieth"];
        Prev_Page = "TCGHighPriestessAlathea";
        Prev_Title = AL["High Priestess A'lathea"];
    };
    ["TCGMasterRaxxieth"] = {
        Title = AL["Master Raxxieth"];
        Next_Page = "TCGTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "TCGFenektistheDeceiver";
        Prev_Title = AL["Fenektis the Deceiver"];
    };
    ["TCGTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "TCGMasterRaxxieth";
        Prev_Title = AL["Master Raxxieth"];
    };
    ["GnGrubbis"] = {
        Title = AL["Grubbis"];
        Next_Page = "GnViscousFallout";
        Next_Title = AL["Viscous Fallout"];
    };
    ["GnViscousFallout"] = {
        Title = AL["Viscous Fallout"];
        Next_Page = "GnElectrocutioner6000";
        Next_Title = AL["Electrocutioner 6000"];
        Prev_Page = "GnGrubbis";
        Prev_Title = AL["Grubbis"];
    };
    ["GnElectrocutioner6000"] = {
        Title = AL["Electrocutioner 6000"];
        Next_Page = "GnCrowdPummeler960";
        Next_Title = AL["Crowd Pummeler 9-60"];
        Prev_Page = "GnViscousFallout";
        Prev_Title = AL["Viscous Fallout"];
    };
    ["GnCrowdPummeler960"] = {
        Title = AL["Crowd Pummeler 9-60"];
        Next_Page = "GnDIAmbassador";
        Next_Title = AL["Dark Iron Ambassador"];
        Prev_Page = "GnElectrocutioner6000";
        Prev_Title = AL["Electrocutioner 6000"];
    };
    ["GnDIAmbassador"] = {
        Title = AL["Dark Iron Ambassador"];
        Next_Page = "GnMekgineerThermaplugg";
        Next_Title = AL["Mekgineer Thermaplugg"];
        Prev_Page = "GnCrowdPummeler960";
        Prev_Title = AL["Crowd Pummeler 9-60"];
    };
    ["GnMekgineerThermaplugg"] = {
        Title = AL["Mekgineer Thermaplugg"];
        Next_Page = "GnTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "GnDIAmbassador";
        Prev_Title = AL["Dark Iron Ambassador"];
    };
    ["GnTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "GnMekgineerThermaplugg";
        Prev_Title = AL["Mekgineer Thermaplugg"];
    };
    ["MCLucifron"] = {
        Title = AL["Lucifron"];
        Next_Page = "MCMagmadar";
        Next_Title = AL["Magmadar"];
    };
    ["MCMagmadar"] = {
        Title = AL["Magmadar"];
        Next_Page = "MCGehennas";
        Next_Title = AL["Gehennas"];
        Prev_Page = "MCLucifron";
        Prev_Title = AL["Lucifron"];
    };
    ["MCGehennas"] = {
        Title = AL["Gehennas"];
        Next_Page = "MCGarr";
        Next_Title = AL["Garr"];
        Prev_Page = "MCMagmadar";
        Prev_Title = AL["Magmadar"];
    };
    ["MCGarr"] = {
        Title = AL["Garr"];
        Next_Page = "MCShazzrah";
        Next_Title = AL["Shazzrah"];
        Prev_Page = "MCGehennas";
        Prev_Title = AL["Gehennas"];
    };
    ["MCShazzrah"] = {
        Title = AL["Shazzrah"];
        Next_Page = "MCGeddon";
        Next_Title = AL["Baron Geddon"];
        Prev_Page = "MCGarr";
        Prev_Title = AL["Garr"];
    };
    ["MCGeddon"] = {
        Title = AL["Baron Geddon"];
        Next_Page = "MCGolemagg";
        Next_Title = AL["Golemagg the Incinerator"];
        Prev_Page = "MCShazzrah";
        Prev_Title = AL["Shazzrah"];
    };
    ["MCGolemagg"] = {
        Title = AL["Golemagg the Incinerator"];
        Next_Page = "MCSulfuron";
        Next_Title = AL["Sulfuron Harbinger"];
        Prev_Page = "MCGeddon";
        Prev_Title = AL["Baron Geddon"];
    };
    ["MCSulfuron"] = {
        Title = AL["Sulfuron Harbinger"];
        Next_Page = "MCMajordomo";
        Next_Title = AL["Majordomo Executus"];
        Prev_Page = "MCGolemagg";
        Prev_Title = AL["Golemagg the Incinerator"];
    };
    ["MCMajordomo"] = {
        Title = AL["Majordomo Executus"];
        Next_Page = "MCRagnaros";
        Next_Title = AL["Ragnaros"];
        Prev_Page = "MCSulfuron";
        Prev_Title = AL["Sulfuron Harbinger"];
    };
    ["MCRagnaros"] = {
        Title = AL["Ragnaros"];
        Next_Page = "MCTrashMobs";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "MCMajordomo";
        Prev_Title = AL["Majordomo Executus"];
    };
    ["MCTrashMobs"] = {
        Title = AL["Trash Mobs"];
        Next_Page = "MCRANDOMBOSSDROPS";
        Next_Title = AL["Random Boss Loot"];
        Prev_Page = "MCRagnaros";
        Prev_Title = AL["Ragnaros"];
    };
    ["MCRANDOMBOSSDROPS"] = {
        Title = AL["Random Boss Loot"];
        Prev_Page = "MCTrashMobs";
        Prev_Title = AL["Trash Mobs"];
    };
    ["NAXPatchwerk"] = {
        Title = AL["Patchwerk"];
        Next_Page = "NAXGrobbulus";
        Next_Title = AL["Grobbulus"];
    };
    ["NAXGrobbulus"] = {
        Title = AL["Grobbulus"];
        Next_Page = "NAXGluth";
        Next_Title = AL["Gluth"];
        Prev_Page = "NAXPatchwerk";
        Prev_Title = AL["Patchwerk"];
    };
    ["NAXGluth"] = {
        Title = AL["Gluth"];
        Next_Page = "NAXThaddius";
        Next_Title = AL["Thaddius"];
        Prev_Page = "NAXGrobbulus";
        Prev_Title = AL["Grobbulus"];
    };
    ["NAXThaddius"] = {
        Title = AL["Thaddius"];
        Next_Page = "NAXAnubRekhan";
        Next_Title = AL["Anub'Rekhan"];
        Prev_Page = "NAXGluth";
        Prev_Title = AL["Gluth"];
    };
    ["NAXAnubRekhan"] = {
        Title = AL["Anub'Rekhan"];
        Next_Page = "NAXGrandWidowFaerlina";
        Next_Title = AL["Grand Widow Faerlina"];
        Prev_Page = "NAXThaddius";
        Prev_Title = AL["Thaddius"];
    };
    ["NAXGrandWidowFaerlina"] = {
        Title = AL["Grand Widow Faerlina"];
        Next_Page = "NAXMaexxna";
        Next_Title = AL["Maexxna"];
        Prev_Page = "NAXAnubRekhan";
        Prev_Title = AL["Anub'Rekhan"];
    };
    ["NAXMaexxna"] = {
        Title = AL["Maexxna"];
        Next_Page = "NAXNoththePlaguebringer";
        Next_Title = AL["Noth the Plaguebringer"];
        Prev_Page = "NAXGrandWidowFaerlina";
        Prev_Title = AL["Grand Widow Faerlina"];
    };
    ["NAXNoththePlaguebringer"] = {
        Title = AL["Noth the Plaguebringer"];
        Next_Page = "NAXHeigantheUnclean";
        Next_Title = AL["Heigan the Unclean"];
        Prev_Page = "NAXMaexxna";
        Prev_Title = AL["Maexxna"];
    };
    ["NAXHeigantheUnclean"] = {
        Title = AL["Heigan the Unclean"];
        Next_Page = "NAXLoatheb";
        Next_Title = AL["Loatheb"];
        Prev_Page = "NAXNoththePlaguebringer";
        Prev_Title = AL["Noth the Plaguebringer"];
    };
    ["NAXLoatheb"] = {
        Title = AL["Loatheb"];
        Next_Page = "NAXInstructorRazuvious";
        Next_Title = AL["Instructor Razuvious"];
        Prev_Page = "NAXHeigantheUnclean";
        Prev_Title = AL["Heigan the Unclean"];
    };
    ["NAXInstructorRazuvious"] = {
        Title = AL["Instructor Razuvious"];
        Next_Page = "NAXGothiktheHarvester";
        Next_Title = AL["Gothik the Harvester"];
        Prev_Page = "NAXLoatheb";
        Prev_Title = AL["Loatheb"];
    };
    ["NAXGothiktheHarvester"] = {
        Title = AL["Gothik the Harvester"];
        Next_Page = "NAXTheFourHorsemen";
        Next_Title = AL["The Four Horsemen"];
        Prev_Page = "NAXInstructorRazuvious";
        Prev_Title = AL["Instructor Razuvious"];
    };
    ["NAXTheFourHorsemen"] = {
        Title = AL["The Four Horsemen"];
        Next_Page = "NAXSapphiron";
        Next_Title = AL["Sapphiron"];
        Prev_Page = "NAXGothiktheHarvester";
        Prev_Title = AL["Gothik the Harvester"];
    };
    ["NAXSapphiron"] = {
        Title = AL["Sapphiron"];
        Next_Page = "NAXKelThuzard";
        Next_Title = AL["Kel'Thuzad"];
        Prev_Page = "NAXTheFourHorsemen";
        Prev_Title = AL["The Four Horsemen"];
    };
    ["NAXKelThuzard"] = {
        Title = AL["Kel'Thuzad"];
        Next_Page = "NAXTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "NAXSapphiron";
        Prev_Title = AL["Sapphiron"];
    };
    ["NAXTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "NAXKelThuzard";
        Prev_Title = AL["Kel'Thuzad"];
    };
    ["SMVishas"] = {
        Title = AL["Interrogator Vishas"];
        Next_Page = "SMScorn";
        Next_Title = AL["Scorn"].." ("..AL["Scourge Invasion"]..")";
    };
    ["SMScorn"] = {
        Title = AL["Scorn"].." ("..AL["Scourge Invasion"]..")";
        Next_Page = "SMIronspine";
        Next_Title = AL["Ironspine"].." ("..AL["Rare"]..")";
        Prev_Page = "SMVishas";
        Prev_Title = AL["Interrogator Vishas"];
    };
    ["SMIronspine"] = {
        Title = AL["Ironspine"].." ("..AL["Rare"]..")";
        Next_Page = "SMAzshir";
        Next_Title = AL["Azshir the Sleepless"].." ("..AL["Rare"]..")";
        Prev_Page = "SMScorn";
        Prev_Title = AL["Scorn"].." ("..AL["Scourge Invasion"]..")";
    };
    ["SMAzshir"] = {
        Title = AL["Azshir the Sleepless"].." ("..AL["Rare"]..")";
        Next_Page = "SMFallenChampion";
        Next_Title = AL["Fallen Champion"].." ("..AL["Rare"]..")";
        Prev_Page = "SMIronspine";
        Prev_Title = AL["Ironspine"].." ("..AL["Rare"]..")";
    };
    ["SMFallenChampion"] = {
        Title = AL["Fallen Champion"].." ("..AL["Rare"]..")";
        Next_Page = "SMBloodmageThalnos";
        Next_Title = AL["Bloodmage Thalnos"];
        Prev_Page = "SMAzshir";
        Prev_Title = AL["Azshir the Sleepless"].." ("..AL["Rare"]..")";
    };
    ["SMBloodmageThalnos"] = {
        Title = AL["Bloodmage Thalnos"];
        Next_Page = "SMGTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "SMFallenChampion";
        Prev_Title = AL["Fallen Champion"].." ("..AL["Rare"]..")";
    };
    ["SMGTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "SMBloodmageThalnos";
        Prev_Title = AL["Bloodmage Thalnos"];
    };
    ["SMHoundmasterLoksey"] = {
        Title = AL["Houndmaster Loksey"];
        Next_Page = "SMDoan";
        Next_Title = AL["Arcanist Doan"];
    };
    ["SMDoan"] = {
        Title = AL["Arcanist Doan"];
        Next_Page = "SMLTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "SMHoundmasterLoksey";
        Prev_Title = AL["Houndmaster Loksey"];
    };
    ["SMLTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "SMDoan";
        Prev_Title = AL["Arcanist Doan"];
    };
    ["SMHerod"] = {
        Title = AL["Herod"];
        Next_Page = "SMATrash";
        Next_Title = AL["Trash Mobs"];
    };
    ["SMATrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "SMHerod";
        Prev_Title = AL["Herod"];
    };
    ["SMFairbanks"] = {
        Title = AL["High Inquisitor Fairbanks"];
        Next_Page = "SMMograine";
        Next_Title = AL["Scarlet Commander Mograine"];
    };
    ["SMMograine"] = {
        Title = AL["Scarlet Commander Mograine"];
        Next_Page = "SMWhitemane";
        Next_Title = AL["High Inquisitor Whitemane"];
        Prev_Page = "SMFairbanks";
        Prev_Title = AL["High Inquisitor Fairbanks"];
    };
    ["SMWhitemane"] = {
        Title = AL["High Inquisitor Whitemane"];
        Next_Page = "SMCTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "SMMograine";
        Prev_Title = AL["Scarlet Commander Mograine"];
    };
    ["SMCTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "SMWhitemane";
        Prev_Title = AL["High Inquisitor Whitemane"];
    };
    ["SCHOLOBlood"] = {
        Title = AL["Blood Steward of Kirtonos"];
        Next_Page = "SCHOLOKirtonostheHerald";
        Next_Title = AL["Kirtonos the Herald"];
    };
    ["SCHOLOKirtonostheHerald"] = {
        Title = AL["Kirtonos the Herald"];
        Next_Page = "SCHOLOJandiceBarov";
        Next_Title = AL["Jandice Barov"];
        Prev_Page = "SCHOLOBlood";
        Prev_Title = AL["Blood Steward of Kirtonos"];
    };
    ["SCHOLOJandiceBarov"] = {
        Title = AL["Jandice Barov"];
        Next_Page = "SCHOLOLordBlackwood";
        Next_Title = AL["Lord Blackwood"].." ("..AL["Scourge Invasion"]..")";
        Prev_Page = "SCHOLOKirtonostheHerald";
        Prev_Title = AL["Kirtonos the Herald"];
    };
    ["SCHOLOLordBlackwood"] = {
        Title = AL["Lord Blackwood"].." ("..AL["Scourge Invasion"]..")";
        Next_Page = "SCHOLORattlegore";
        Next_Title = AL["Rattlegore"];
        Prev_Page = "SCHOLOJandiceBarov";
        Prev_Title = AL["Jandice Barov"];
    };
    ["SCHOLORattlegore"] = {
        Title = AL["Rattlegore"];
        Next_Page = "SCHOLODeathKnight";
        Next_Title = AL["Death Knight Darkreaver"];
        Prev_Page = "SCHOLOLordBlackwood";
        Prev_Title = AL["Lord Blackwood"].." ("..AL["Scourge Invasion"]..")";
    };
    ["SCHOLODeathKnight"] = {
        Title = AL["Death Knight Darkreaver"];
        Next_Page = "SCHOLOMarduk";
        Next_Title = AL["Marduk Blackpool"];
        Prev_Page = "SCHOLORattlegore";
        Prev_Title = AL["Rattlegore"];
    };
    ["SCHOLOMarduk"] = {
        Title = AL["Marduk Blackpool"];
        Next_Page = "SCHOLOVectus";
        Next_Title = AL["Vectus"];
        Prev_Page = "SCHOLODeathKnight";
        Prev_Title = AL["Death Knight Darkreaver"];
    };
    ["SCHOLOVectus"] = {
        Title = AL["Vectus"];
        Next_Page = "SCHOLORasFrostwhisper";
        Next_Title = AL["Ras Frostwhisper"];
        Prev_Page = "SCHOLOMarduk";
        Prev_Title = AL["Marduk Blackpool"];
    };
    ["SCHOLORasFrostwhisper"] = {
        Title = AL["Ras Frostwhisper"];
        Next_Page = "SCHOLOKormok";
        Next_Title = AL["Kormok"];
        Prev_Page = "SCHOLOVectus";
        Prev_Title = AL["Vectus"];
    };
    ["SCHOLOKormok"] = {
        Title = AL["Kormok"];
        Next_Page = "SCHOLOInstructorMalicia";
        Next_Title = AL["Instructor Malicia"];
        Prev_Page = "SCHOLORasFrostwhisper";
        Prev_Title = AL["Ras Frostwhisper"];
    };
    ["SCHOLOInstructorMalicia"] = {
        Title = AL["Instructor Malicia"];
        Next_Page = "SCHOLODoctorTheolenKrastinov";
        Next_Title = AL["Doctor Theolen Krastinov"];
        Prev_Page = "SCHOLOKormok";
        Prev_Title = AL["Kormok"];
    };
    ["SCHOLODoctorTheolenKrastinov"] = {
        Title = AL["Doctor Theolen Krastinov"];
        Next_Page = "SCHOLOLorekeeperPolkelt";
        Next_Title = AL["Lorekeeper Polkelt"];
        Prev_Page = "SCHOLOInstructorMalicia";
        Prev_Title = AL["Instructor Malicia"];
    };
    ["SCHOLOLorekeeperPolkelt"] = {
        Title = AL["Lorekeeper Polkelt"];
        Next_Page = "SCHOLOTheRavenian";
        Next_Title = AL["The Ravenian"];
        Prev_Page = "SCHOLODoctorTheolenKrastinov";
        Prev_Title = AL["Doctor Theolen Krastinov"];
    };
    ["SCHOLOTheRavenian"] = {
        Title = AL["The Ravenian"];
        Next_Page = "SCHOLOLordAlexeiBarov";
        Next_Title = AL["Lord Alexei Barov"];
        Prev_Page = "SCHOLOLorekeeperPolkelt";
        Prev_Title = AL["Lorekeeper Polkelt"];
    };
    ["SCHOLOLordAlexeiBarov"] = {
        Title = AL["Lord Alexei Barov"];
        Next_Page = "SCHOLOLadyIlluciaBarov";
        Next_Title = AL["Lady Illucia Barov"];
        Prev_Page = "SCHOLOTheRavenian";
        Prev_Title = AL["The Ravenian"];
    };
    ["SCHOLOLadyIlluciaBarov"] = {
        Title = AL["Lady Illucia Barov"];
        Next_Page = "SCHOLODarkmasterGandling";
        Next_Title = AL["Darkmaster Gandling"];
        Prev_Page = "SCHOLOLordAlexeiBarov";
        Prev_Title = AL["Lord Alexei Barov"];
    };
    ["SCHOLODarkmasterGandling"] = {
        Title = AL["Darkmaster Gandling"];
        Next_Page = "SCHOLOTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "SCHOLOLadyIlluciaBarov";
        Prev_Title = AL["Lady Illucia Barov"];
    };
    ["SCHOLOTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "SCHOLODarkmasterGandling";
        Prev_Title = AL["Darkmaster Gandling"];
    };
    ["SFKRethilgore"] = {
        Title = AL["Rethilgore"];
        Next_Page = "SFKFelSteed";
        Next_Title = AL["Fel Steed"];
    };
    ["SFKFelSteed"] = {
        Title = AL["Fel Steed"];
        Next_Page = "SFKRazorclawtheButcher";
        Next_Title = AL["Razorclaw the Butcher"];
        Prev_Page = "SFKRethilgore";
        Prev_Title = AL["Rethilgore"];
    };
    ["SFKRazorclawtheButcher"] = {
        Title = AL["Razorclaw the Butcher"];
        Next_Page = "SFKSilverlaine";
        Next_Title = AL["Baron Silverlaine"];
        Prev_Page = "SFKFelSteed";
        Prev_Title = AL["Fel Steed"];
    };
    ["SFKSilverlaine"] = {
        Title = AL["Baron Silverlaine"];
        Next_Page = "SFKSpringvale";
        Next_Title = AL["Commander Springvale"];
        Prev_Page = "SFKRazorclawtheButcher";
        Prev_Title = AL["Razorclaw the Butcher"];
    };
    ["SFKSpringvale"] = {
        Title = AL["Commander Springvale"];
        Next_Page = "SFKSever";
        Next_Title = AL["Sever"].." ("..AL["Scourge Invasion"]..")";
        Prev_Page = "SFKSilverlaine";
        Prev_Title = AL["Baron Silverlaine"];
    };
    ["SFKSever"] = {
        Title = AL["Sever"].." ("..AL["Scourge Invasion"]..")";
        Next_Page = "SFKOdotheBlindwatcher";
        Next_Title = AL["Odo the Blindwatcher"];
        Prev_Page = "SFKSpringvale";
        Prev_Title = AL["Commander Springvale"];
    };
    ["SFKOdotheBlindwatcher"] = {
        Title = AL["Odo the Blindwatcher"];
        Next_Page = "SFKDeathswornCaptain";
        Next_Title = AL["Deathsworn Captain"].." ("..AL["Rare"]..")";
        Prev_Page = "SFKSever";
        Prev_Title = AL["Sever"].." ("..AL["Scourge Invasion"]..")";
    };
    ["SFKDeathswornCaptain"] = {
        Title = AL["Deathsworn Captain"].." ("..AL["Rare"]..")";
        Next_Page = "SFKFenrustheDevourer";
        Next_Title = AL["Fenrus the Devourer"];
        Prev_Page = "SFKOdotheBlindwatcher";
        Prev_Title = AL["Odo the Blindwatcher"];
    };
    ["SFKFenrustheDevourer"] = {
        Title = AL["Fenrus the Devourer"];
        Next_Page = "SFKArugalsVoidwalker";
        Next_Title = AL["Arugal's Voidwalker"];
        Prev_Page = "SFKDeathswornCaptain";
        Prev_Title = AL["Deathsworn Captain"].." ("..AL["Rare"]..")";
    };
    ["SFKArugalsVoidwalker"] = {
        Title = AL["Arugal's Voidwalker"];
        Next_Page = "SFKWolfMasterNandos";
        Next_Title = AL["Wolf Master Nandos"];
        Prev_Page = "SFKFenrustheDevourer";
        Prev_Title = AL["Fenrus the Devourer"];
    };
    ["SFKWolfMasterNandos"] = {
        Title = AL["Wolf Master Nandos"];
        Next_Page = "SFKArchmageArugal";
        Next_Title = AL["Archmage Arugal"];
        Prev_Page = "SFKArugalsVoidwalker";
        Prev_Title = AL["Arugal's Voidwalker"];
    };
    ["SFKArchmageArugal"] = {
        Title = AL["Archmage Arugal"];
        Next_Page = "SFKTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "SFKWolfMasterNandos";
        Prev_Title = AL["Wolf Master Nandos"];
    };
    ["SFKTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "SFKArchmageArugal";
        Prev_Title = AL["Archmage Arugal"];
    };
    ["SWStTargorr"] = {
        Title = AL["Targorr the Dread"];
        Next_Page = "SWStKamDeepfury";
        Next_Title = AL["Kam Deepfury"];
    };
    ["SWStKamDeepfury"] = {
        Title = AL["Kam Deepfury"];
        Next_Page = "SWStHamhock";
        Next_Title = AL["Hamhock"];
        Prev_Page = "SWStTargorr";
        Prev_Title = AL["Targorr the Dread"];
    };
    ["SWStHamhock"] = {
        Title = AL["Hamhock"];
        Next_Page = "SWStDextren";
        Next_Title = AL["Dextren Ward"];
        Prev_Page = "SWStKamDeepfury";
        Prev_Title = AL["Kam Deepfury"];
    };
    ["SWStDextren"] = {
        Title = AL["Dextren Ward"];
        Next_Page = "SWStBazil";
        Next_Title = AL["Bazil Thredd"];
        Prev_Page = "SWStHamhock";
        Prev_Title = AL["Hamhock"];
    };
    ["SWStBazil"] = {
        Title = AL["Bazil Thredd"];
        Next_Page = "SWStBruegalIronknuckle";
        Next_Title = AL["Bruegal Ironknuckle"].." ("..AL["Rare"]..")";
        Prev_Page = "SWStDextren";
        Prev_Title = AL["Dextren Ward"];
    };
    ["SWStBruegalIronknuckle"] = {
        Title = AL["Bruegal Ironknuckle"].." ("..AL["Rare"]..")";
        Next_Page = "SWStTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "SWStBazil";
        Prev_Title = AL["Bazil Thredd"];
    };
    ["SWStTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "SWStBruegalIronknuckle";
        Prev_Title = AL["Bruegal Ironknuckle"].." ("..AL["Rare"]..")";
    };
    ["STRATSkull"] = {
        Title = AL["Skul"].." ("..AL["Rare"]..")";
        Next_Page = "STRATStratholmeCourier";
        Next_Title = AL["Stratholme Courier"];
    };
    ["STRATStratholmeCourier"] = {
        Title = AL["Stratholme Courier"];
        Next_Page = "STRATPostmaster";
        Next_Title = AL["Postmaster Malown"];
        Prev_Page = "STRATSkull";
        Prev_Title = AL["Skul"].." ("..AL["Rare"]..")";
    };
    ["STRATPostmaster"] = {
        Title = AL["Postmaster Malown"];
        Next_Page = "STRATFrasSiabi";
        Next_Title = AL["Fras Siabi"];
        Prev_Page = "STRATStratholmeCourier";
        Prev_Title = AL["Stratholme Courier"];
    };
    ["STRATFrasSiabi"] = {
        Title = AL["Fras Siabi"];
        Next_Page = "STRATAtiesh";
        Next_Title = AL["Atiesh"];
        Prev_Page = "STRATPostmaster";
        Prev_Title = AL["Postmaster Malown"];
    };
    ["STRATAtiesh"] = {
        Title = AL["Atiesh"];
        Next_Page = "STRATBalzaphon";
        Next_Title = AL["Balzaphon"].." ("..AL["Scourge Invasion"]..")";
        Prev_Page = "STRATFrasSiabi";
        Prev_Title = AL["Fras Siabi"];
    };
    ["STRATBalzaphon"] = {
        Title = AL["Balzaphon"].." ("..AL["Scourge Invasion"]..")";
        Next_Page = "STRATHearthsingerForresten";
        Next_Title = AL["Hearthsinger Forresten"].." ("..AL["Rare"]..")";
        Prev_Page = "STRATAtiesh";
        Prev_Title = AL["Atiesh"];
    };
    ["STRATHearthsingerForresten"] = {
        Title = AL["Hearthsinger Forresten"].." ("..AL["Rare"]..")";
        Next_Page = "STRATTheUnforgiven";
        Next_Title = AL["The Unforgiven"];
        Prev_Page = "STRATBalzaphon";
        Prev_Title = AL["Balzaphon"].." ("..AL["Scourge Invasion"]..")";
    };
    ["STRATTheUnforgiven"] = {
        Title = AL["The Unforgiven"];
        Next_Page = "STRATTimmytheCruel";
        Next_Title = AL["Timmy the Cruel"];
        Prev_Page = "STRATHearthsingerForresten";
        Prev_Title = AL["Hearthsinger Forresten"].." ("..AL["Rare"]..")";
    };
    ["STRATTimmytheCruel"] = {
        Title = AL["Timmy the Cruel"];
        Next_Page = "STRATMalor";
        Next_Title = AL["Malor the Zealous"];
        Prev_Page = "STRATTheUnforgiven";
        Prev_Title = AL["The Unforgiven"];
    };
    ["STRATMalor"] = {
        Title = AL["Malor the Zealous"];
        Next_Page = "STRATMalorsStrongbox";
        Next_Title = AL["Malor's Strongbox"];
        Prev_Page = "STRATTimmytheCruel";
        Prev_Title = AL["Timmy the Cruel"];
    };
    ["STRATMalorsStrongbox"] = {
        Title = AL["Malor's Strongbox"];
        Next_Page = "STRATCrimsonHammersmith";
        Next_Title = AL["Crimson Hammersmith"];
        Prev_Page = "STRATMalor";
        Prev_Title = AL["Malor the Zealous"];
    };
    ["STRATCrimsonHammersmith"] = {
        Title = AL["Crimson Hammersmith"];
        Next_Page = "STRATCannonMasterWilley";
        Next_Title = AL["Cannon Master Willey"];
        Prev_Page = "STRATMalorsStrongbox";
        Prev_Title = AL["Malor's Strongbox"];
    };
    ["STRATCannonMasterWilley"] = {
        Title = AL["Cannon Master Willey"];
        Next_Page = "STRATArchivistGalford";
        Next_Title = AL["Archivist Galford"];
        Prev_Page = "STRATCrimsonHammersmith";
        Prev_Title = AL["Crimson Hammersmith"];
    };
    ["STRATArchivistGalford"] = {
        Title = AL["Archivist Galford"];
        Next_Page = "STRATBalnazzar";
        Next_Title = AL["Balnazzar"];
        Prev_Page = "STRATCannonMasterWilley";
        Prev_Title = AL["Cannon Master Willey"];
    };
    ["STRATBalnazzar"] = {
        Title = AL["Balnazzar"];
        Next_Page = "STRATSothosJarien";
        Next_Title = AL["Sothos"].." & "..AL["Jarien"];
        Prev_Page = "STRATArchivistGalford";
        Prev_Title = AL["Archivist Galford"];
    };
    ["STRATSothosJarien"] = {
        Title = AL["Sothos"].." & "..AL["Jarien"];
        Next_Page = "STRATStonespine";
        Next_Title = AL["Stonespine"].." ("..AL["Rare"]..")";
        Prev_Page = "STRATBalnazzar";
        Prev_Title = AL["Balnazzar"];
    };
    ["STRATStonespine"] = {
        Title = AL["Stonespine"].." ("..AL["Rare"]..")";
        Next_Page = "STRATBaronessAnastari";
        Next_Title = AL["Baroness Anastari"];
        Prev_Page = "STRATSothosJarien";
        Prev_Title = AL["Sothos"].." & "..AL["Jarien"];
    };
    ["STRATBaronessAnastari"] = {
        Title = AL["Baroness Anastari"];
        Next_Page = "STRATBlackGuardSwordsmith";
        Next_Title = AL["Black Guard Swordsmith"];
        Prev_Page = "STRATStonespine";
        Prev_Title = AL["Stonespine"].." ("..AL["Rare"]..")";
    };
    ["STRATBlackGuardSwordsmith"] = {
        Title = AL["Black Guard Swordsmith"];
        Next_Page = "STRATNerubenkan";
        Next_Title = AL["Nerub'enkan"];
        Prev_Page = "STRATBaronessAnastari";
        Prev_Title = AL["Baroness Anastari"];
    };
    ["STRATNerubenkan"] = {
        Title = AL["Nerub'enkan"];
        Next_Page = "STRATMalekithePallid";
        Next_Title = AL["Maleki the Pallid"];
        Prev_Page = "STRATBlackGuardSwordsmith";
        Prev_Title = AL["Black Guard Swordsmith"];
    };
    ["STRATMalekithePallid"] = {
        Title = AL["Maleki the Pallid"];
        Next_Page = "STRATMagistrateBarthilas";
        Next_Title = AL["Magistrate Barthilas"];
        Prev_Page = "STRATNerubenkan";
        Prev_Title = AL["Nerub'enkan"];
    };
    ["STRATMagistrateBarthilas"] = {
        Title = AL["Magistrate Barthilas"];
        Next_Page = "STRATRamsteintheGorger";
        Next_Title = AL["Ramstein the Gorger"];
        Prev_Page = "STRATMalekithePallid";
        Prev_Title = AL["Maleki the Pallid"];
    };
    ["STRATRamsteintheGorger"] = {
        Title = AL["Ramstein the Gorger"];
        Next_Page = "STRATBaronRivendare";
        Next_Title = AL["Baron Rivendare"];
        Prev_Page = "STRATMagistrateBarthilas";
        Prev_Title = AL["Magistrate Barthilas"];
    };
    ["STRATBaronRivendare"] = {
        Title = AL["Baron Rivendare"];
        Next_Page = "STRATTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "STRATRamsteintheGorger";
        Prev_Title = AL["Ramstein the Gorger"];
    };
    ["STRATTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "STRATBaronRivendare";
        Prev_Title = AL["Baron Rivendare"];
    };
    ["STBalconyMinibosses"] = {
        Title = AL["Balcony Minibosses"];
        Next_Page = "STAtalalarion";
        Next_Title = AL["Atal'alarion"];
    };
    ["STAtalalarion"] = {
        Title = AL["Atal'alarion"];
        Next_Page = "STSpawnOfHakkar";
        Next_Title = AL["Spawn of Hakkar"];
        Prev_Page = "STBalconyMinibosses";
        Prev_Title = AL["Balcony Minibosses"];
    };
    ["STSpawnOfHakkar"] = {
        Title = AL["Spawn of Hakkar"];
        Next_Page = "STAvatarofHakkar";
        Next_Title = AL["Avatar of Hakkar"];
        Prev_Page = "STAtalalarion";
        Prev_Title = AL["Atal'alarion"];
    };
    ["STAvatarofHakkar"] = {
        Title = AL["Avatar of Hakkar"];
        Next_Page = "STJammalan";
        Next_Title = AL["Jammal'an the Prophet"];
        Prev_Page = "STSpawnOfHakkar";
        Prev_Title = AL["Spawn of Hakkar"];
    };
    ["STJammalan"] = {
        Title = AL["Jammal'an the Prophet"];
        Next_Page = "STOgom";
        Next_Title = AL["Ogom the Wretched"];
        Prev_Page = "STAvatarofHakkar";
        Prev_Title = AL["Avatar of Hakkar"];
    };
    ["STOgom"] = {
        Title = AL["Ogom the Wretched"];
        Next_Page = "STDreamscythe";
        Next_Title = AL["Dreamscythe"];
        Prev_Page = "STJammalan";
        Prev_Title = AL["Jammal'an the Prophet"];
    };
    ["STDreamscythe"] = {
        Title = AL["Dreamscythe"];
        Next_Page = "STWeaver";
        Next_Title = AL["Weaver"];
        Prev_Page = "STOgom";
        Prev_Title = AL["Ogom the Wretched"];
    };
    ["STWeaver"] = {
        Title = AL["Weaver"];
        Next_Page = "STMorphaz";
        Next_Title = AL["Morphaz"];
        Prev_Page = "STDreamscythe";
        Prev_Title = AL["Dreamscythe"];
    };
    ["STMorphaz"] = {
        Title = AL["Morphaz"];
        Next_Page = "STHazzas";
        Next_Title = AL["Hazzas"];
        Prev_Page = "STWeaver";
        Prev_Title = AL["Weaver"];
    };
    ["STHazzas"] = {
        Title = AL["Hazzas"];
        Next_Page = "STEranikus";
        Next_Title = AL["Shade of Eranikus"];
        Prev_Page = "STMorphaz";
        Prev_Title = AL["Morphaz"];
    };
    ["STEranikus"] = {
        Title = AL["Shade of Eranikus"];
        Next_Page = "STTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "STHazzas";
        Prev_Title = AL["Hazzas"];
    };
    ["STTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "STEranikus";
        Prev_Title = AL["Shade of Eranikus"];
    };
    ["UldBaelog"] = {
        Title = AL["Baelog"];
        Next_Page = "UldOlaf";
        Next_Title = AL["Olaf"];
    };
    ["UldOlaf"] = {
        Title = AL["Olaf"];
        Next_Page = "UldEric";
        Next_Title = AL["Eric 'The Swift'"];
        Prev_Page = "UldBaelog";
        Prev_Title = AL["Baelog"];
    };
    ["UldEric"] = {
        Title = AL["Eric 'The Swift'"];
        Next_Page = "UldRevelosh";
        Next_Title = AL["Revelosh"];
        Prev_Page = "UldOlaf";
        Prev_Title = AL["Olaf"];
    };
    ["UldRevelosh"] = {
        Title = AL["Revelosh"];
        Next_Page = "UldIronaya";
        Next_Title = AL["Ironaya"];
        Prev_Page = "UldEric";
        Prev_Title = AL["Eric 'The Swift'"];
    };
    ["UldIronaya"] = {
        Title = AL["Ironaya"];
        Next_Page = "UldAncientStoneKeeper";
        Next_Title = AL["Ancient Stone Keeper"];
        Prev_Page = "UldRevelosh";
        Prev_Title = AL["Revelosh"];
    };
    ["UldAncientStoneKeeper"] = {
        Title = AL["Ancient Stone Keeper"];
        Next_Page = "UldGalgannFirehammer";
        Next_Title = AL["Galgann Firehammer"];
        Prev_Page = "UldIronaya";
        Prev_Title = AL["Ironaya"];
    };
    ["UldGalgannFirehammer"] = {
        Title = AL["Galgann Firehammer"];
        Next_Page = "UldGrimlok";
        Next_Title = AL["Grimlok"];
        Prev_Page = "UldAncientStoneKeeper";
        Prev_Title = AL["Ancient Stone Keeper"];
    };
    ["UldGrimlok"] = {
        Title = AL["Grimlok"];
        Next_Page = "UldArchaedas";
        Next_Title = AL["Archaedas"];
        Prev_Page = "UldGalgannFirehammer";
        Prev_Title = AL["Galgann Firehammer"];
    };
    ["UldArchaedas"] = {
        Title = AL["Archaedas"];
        Next_Page = "UldTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "UldGrimlok";
        Prev_Title = AL["Grimlok"];
    };
    ["UldTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "UldArchaedas";
        Prev_Title = AL["Archaedas"];
    };
    ["ZGJeklik"] = {
        Title = AL["High Priestess Jeklik"];
        Next_Page = "ZGVenoxis";
        Next_Title = AL["High Priest Venoxis"];
    };
    ["ZGVenoxis"] = {
        Title = AL["High Priest Venoxis"];
        Next_Page = "ZGMarli";
        Next_Title = AL["High Priestess Mar'li"];
        Prev_Page = "ZGJeklik";
        Prev_Title = AL["High Priestess Jeklik"];
    };
    ["ZGMarli"] = {
        Title = AL["High Priestess Mar'li"];
        Next_Page = "ZGMandokir";
        Next_Title = AL["Bloodlord Mandokir"];
        Prev_Page = "ZGVenoxis";
        Prev_Title = AL["High Priest Venoxis"];
    };
    ["ZGMandokir"] = {
        Title = AL["Bloodlord Mandokir"];
        Next_Page = "ZGGrilek";
        Next_Title = AL["Gri'lek"];
        Prev_Page = "ZGMarli";
        Prev_Title = AL["High Priestess Mar'li"];
    };
    ["ZGGrilek"] = {
        Title = AL["Gri'lek"];
        Next_Page = "ZGHazzarah";
        Next_Title = AL["Hazza'rah"];
        Prev_Page = "ZGMandokir";
        Prev_Title = AL["Bloodlord Mandokir"];
    };
    ["ZGHazzarah"] = {
        Title = AL["Hazza'rah"];
        Next_Page = "ZGRenataki";
        Next_Title = AL["Renataki"];
        Prev_Page = "ZGGrilek";
        Prev_Title = AL["Gri'lek"];
    };
    ["ZGRenataki"] = {
        Title = AL["Renataki"];
        Next_Page = "ZGWushoolay";
        Next_Title = AL["Wushoolay"];
        Prev_Page = "ZGHazzarah";
        Prev_Title = AL["Hazza'rah"];
    };
    ["ZGWushoolay"] = {
        Title = AL["Wushoolay"];
        Next_Page = "ZGGahzranka";
        Next_Title = AL["Gahz'ranka"];
        Prev_Page = "ZGRenataki";
        Prev_Title = AL["Renataki"];
    };
    ["ZGGahzranka"] = {
        Title = AL["Gahz'ranka"];
        Next_Page = "ZGThekal";
        Next_Title = AL["High Priest Thekal"];
        Prev_Page = "ZGWushoolay";
        Prev_Title = AL["Wushoolay"];
    };
    ["ZGThekal"] = {
        Title = AL["High Priest Thekal"];
        Next_Page = "ZGArlokk";
        Next_Title = AL["High Priestess Arlokk"];
        Prev_Page = "ZGGahzranka";
        Prev_Title = AL["Gahz'ranka"];
    };
    ["ZGArlokk"] = {
        Title = AL["High Priestess Arlokk"];
        Next_Page = "ZGJindo";
        Next_Title = AL["Jin'do the Hexxer"];
        Prev_Page = "ZGThekal";
        Prev_Title = AL["High Priest Thekal"];
    };
    ["ZGJindo"] = {
        Title = AL["Jin'do the Hexxer"];
        Next_Page = "ZGHakkar";
        Next_Title = AL["Hakkar"];
        Prev_Page = "ZGArlokk";
        Prev_Title = AL["High Priestess Arlokk"];
    };
    ["ZGHakkar"] = {
        Title = AL["Hakkar"];
        Next_Page = "ZGShared";
        Next_Title = AL["Random Boss Loot"];
        Prev_Page = "ZGJindo";
        Prev_Title = AL["Jin'do the Hexxer"];
    };
    ["ZGShared"] = {
        Title = AL["Random Boss Loot"];
        Next_Page = "ZGTrash1";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "ZGHakkar";
        Prev_Title = AL["Hakkar"];
    };
    ["ZGTrash1"] = {
        Title = AL["Trash Mobs"];
        Next_Page = "ZGEnchants";
        Next_Title = AL["ZG Enchants"];
        Prev_Page = "ZGShared";
        Prev_Title = AL["Random Boss Loot"];
    };
    ["ZGEnchants"] = {
        Title = AL["ZG Enchants"];
        Prev_Page = "ZGTrash1";
        Prev_Title = AL["Trash Mobs"];
    };
    ["BFDGhamoora"] = {
        Title = AL["Ghamoo-ra"];
        Next_Page = "BFDLadySarevess";
        Next_Title = AL["Lady Sarevess"];
    };
    ["BFDLadySarevess"] = {
        Title = AL["Lady Sarevess"];
        Next_Page = "BFDGelihast";
        Next_Title = AL["Gelihast"];
        Prev_Page = "BFDGhamoora";
        Prev_Title = AL["Ghamoo-ra"];
    };
    ["BFDGelihast"] = {
        Title = AL["Gelihast"];
        Next_Page = "BFDBaronAquanis";
        Next_Title = AL["Baron Aquanis"];
        Prev_Page = "BFDLadySarevess";
        Prev_Title = AL["Lady Sarevess"];
    };
    ["BFDBaronAquanis"] = {
        Title = AL["Baron Aquanis"];
        Next_Page = "BFDTwilightLordKelris";
        Next_Title = AL["Twilight Lord Kelris"];
        Prev_Page = "BFDGelihast";
        Prev_Title = AL["Gelihast"];
    };
    ["BFDTwilightLordKelris"] = {
        Title = AL["Twilight Lord Kelris"];
        Next_Page = "BFDOldSerrakis";
        Next_Title = AL["Old Serra'kis"];
        Prev_Page = "BFDBaronAquanis";
        Prev_Title = AL["Baron Aquanis"];
    };
    ["BFDOldSerrakis"] = {
        Title = AL["Old Serra'kis"];
        Next_Page = "BFDAkumai";
        Next_Title = AL["Aku'mai"];
        Prev_Page = "BFDTwilightLordKelris";
        Prev_Title = AL["Twilight Lord Kelris"];
    };
    ["BFDAkumai"] = {
        Title = AL["Aku'mai"];
        Next_Page = "BFDTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "BFDOldSerrakis";
        Prev_Title = AL["Old Serra'kis"];
    };
    ["BFDTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "BFDAkumai";
        Prev_Title = AL["Aku'mai"];
    };
    ["DMEPusillin"] = {
        Title = AL["Pusillin"];
        Next_Page = "DMEZevrimThornhoof";
        Next_Title = AL["Zevrim Thornhoof"];
    };
    ["DMEZevrimThornhoof"] = {
        Title = AL["Zevrim Thornhoof"];
        Next_Page = "DMEHydro";
        Next_Title = AL["Hydrospawn"];
        Prev_Page = "DMEPusillin";
        Prev_Title = AL["Pusillin"];
    };
    ["DMEHydro"] = {
        Title = AL["Hydrospawn"];
        Next_Page = "DMELethtendris";
        Next_Title = AL["Lethtendris"];
        Prev_Page = "DMEZevrimThornhoof";
        Prev_Title = AL["Zevrim Thornhoof"];
    };
    ["DMELethtendris"] = {
        Title = AL["Lethtendris"];
        Next_Page = "DMEPimgib";
        Next_Title = AL["Pimgib"];
        Prev_Page = "DMEHydro";
        Prev_Title = AL["Hydrospawn"];
    };
    ["DMEPimgib"] = {
        Title = AL["Pimgib"];
        Next_Page = "DMEIsalien";
        Next_Title = AL["Isalien"];
        Prev_Page = "DMELethtendris";
        Prev_Title = AL["Lethtendris"];
    };
    ["DMEIsalien"] = {
        Title = AL["Isalien"];
        Next_Page = "DMEAlzzin";
        Next_Title = AL["Alzzin the Wildshaper"];
        Prev_Page = "DMEPimgib";
        Prev_Title = AL["Pimgib"];
    };
    ["DMEAlzzin"] = {
        Title = AL["Alzzin the Wildshaper"];
        Next_Page = "DMETrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "DMEIsalien";
        Prev_Title = AL["Isalien"];
    };
    ["DMETrash"] = {
        Title = AL["Trash Mobs"];
        Next_Page = "DMBooks";
        Next_Title = AL["Dire Maul Books"];
        Prev_Page = "DMEAlzzin";
        Prev_Title = AL["Alzzin the Wildshaper"];
    };
    ["DMBooks"] = {
        Title = AL["Dire Maul Books"];
        Prev_Page = "DMETrash";
        Prev_Title = AL["Trash Mobs"];
    };
    ["DMWTendrisWarpwood"] = {
        Title = AL["Tendris Warpwood"];
        Next_Page = "DMWIllyannaRavenoak";
        Next_Title = AL["Illyanna Ravenoak"];
    };
    ["DMWIllyannaRavenoak"] = {
        Title = AL["Illyanna Ravenoak"];
        Next_Page = "DMWMagisterKalendris";
        Next_Title = AL["Magister Kalendris"];
        Prev_Page = "DMWTendrisWarpwood";
        Prev_Title = AL["Tendris Warpwood"];
    };
    ["DMWMagisterKalendris"] = {
        Title = AL["Magister Kalendris"];
        Next_Page = "DMWTsuzee";
        Next_Title = AL["Tsu'zee"].." ("..AL["Rare"]..")";
        Prev_Page = "DMWIllyannaRavenoak";
        Prev_Title = AL["Illyanna Ravenoak"];
    };
    ["DMWTsuzee"] = {
        Title = AL["Tsu'zee"].." ("..AL["Rare"]..")";
        Next_Page = "DMWRevanchion";
        Next_Title = AL["Revanchion"].." ("..AL["Scourge Invasion"]..")";
        Prev_Page = "DMWMagisterKalendris";
        Prev_Title = AL["Magister Kalendris"];
    };
    ["DMWRevanchion"] = {
        Title = AL["Revanchion"].." ("..AL["Scourge Invasion"]..")";
        Next_Page = "DMWImmolthar";
        Next_Title = AL["Immol'thar"];
        Prev_Page = "DMWTsuzee";
        Prev_Title = AL["Tsu'zee"].." ("..AL["Rare"]..")";
    };
    ["DMWImmolthar"] = {
        Title = AL["Immol'thar"];
        Next_Page = "DMWHelnurath";
        Next_Title = AL["Lord Hel'nurath"].." ("..AL["Rare"]..")";
        Prev_Page = "DMWRevanchion";
        Prev_Title = AL["Revanchion"].." ("..AL["Scourge Invasion"]..")";
    };
    ["DMWHelnurath"] = {
        Title = AL["Lord Hel'nurath"].." ("..AL["Rare"]..")";
        Next_Page = "DMWPrinceTortheldrin";
        Next_Title = AL["Prince Tortheldrin"];
        Prev_Page = "DMWImmolthar";
        Prev_Title = AL["Immol'thar"];
    };
    ["DMWPrinceTortheldrin"] = {
        Title = AL["Prince Tortheldrin"];
        Next_Page = "DMWTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "DMWHelnurath";
        Prev_Title = AL["Lord Hel'nurath"].." ("..AL["Rare"]..")";
    };
    ["DMWTrash"] = {
        Title = AL["Trash Mobs"];
        Next_Page = "DMBooks";
        Next_Title = AL["Dire Maul Books"];
        Prev_Page = "DMWPrinceTortheldrin";
        Prev_Title = AL["Prince Tortheldrin"];
    };
    ["DMBooks"] = {
        Title = AL["Dire Maul Books"];
        Prev_Page = "DMWTrash";
        Prev_Title = AL["Trash Mobs"];
    };
    ["DMNGuardMoldar"] = {
        Title = AL["Guard Mol'dar"];
        Next_Page = "DMNStomperKreeg";
        Next_Title = AL["Stomper Kreeg"];
    };
    ["DMNStomperKreeg"] = {
        Title = AL["Stomper Kreeg"];
        Next_Page = "DMNGuardFengus";
        Next_Title = AL["Guard Fengus"];
        Prev_Page = "DMNGuardMoldar";
        Prev_Title = AL["Guard Mol'dar"];
    };
    ["DMNGuardFengus"] = {
        Title = AL["Guard Fengus"];
        Next_Page = "DMNThimblejack";
        Next_Title = AL["Knot Thimblejack"];
        Prev_Page = "DMNStomperKreeg";
        Prev_Title = AL["Stomper Kreeg"];
    };
    ["DMNThimblejack"] = {
        Title = AL["Knot Thimblejack"];
        Next_Page = "DMNGuardSlipkik";
        Next_Title = AL["Guard Slip'kik"];
        Prev_Page = "DMNGuardFengus";
        Prev_Title = AL["Guard Fengus"];
    };
    ["DMNGuardSlipkik"] = {
        Title = AL["Guard Slip'kik"];
        Next_Page = "DMNCaptainKromcrush";
        Next_Title = AL["Captain Kromcrush"];
        Prev_Page = "DMNThimblejack";
        Prev_Title = AL["Knot Thimblejack"];
    };
    ["DMNCaptainKromcrush"] = {
        Title = AL["Captain Kromcrush"];
        Next_Page = "DMNChoRush";
        Next_Title = AL["Cho'Rush the Observer"];
        Prev_Page = "DMNGuardSlipkik";
        Prev_Title = AL["Guard Slip'kik"];
    };
    ["DMNChoRush"] = {
        Title = AL["Cho'Rush the Observer"];
        Next_Page = "DMNKingGordok";
        Next_Title = AL["King Gordok"];
        Prev_Page = "DMNCaptainKromcrush";
        Prev_Title = AL["Captain Kromcrush"];
    };
    ["DMNKingGordok"] = {
        Title = AL["King Gordok"];
        Next_Page = "DMNTRIBUTERUN";
        Next_Title = AL["Tribute Run"];
        Prev_Page = "DMNChoRush";
        Prev_Title = AL["Cho'Rush the Observer"];
    };
    ["DMNTRIBUTERUN"] = {
        Title = AL["Tribute Run"];
        Next_Page = "DMNTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "DMNKingGordok";
        Prev_Title = AL["King Gordok"];
    };
    ["DMNTrash"] = {
        Title = AL["Trash Mobs"];
        Next_Page = "DMBooks";
        Next_Title = AL["Dire Maul Books"];
        Prev_Page = "DMNTRIBUTERUN";
        Prev_Title = AL["Tribute Run"];
    };
    ["DMBooks"] = {
        Title = AL["Dire Maul Books"];
        Prev_Page = "DMNTrash";
        Prev_Title = AL["Trash Mobs"];
    };
    ["MaraNoxxion"] = {
        Title = AL["Noxxion"];
        Next_Page = "MaraRazorlash";
        Next_Title = AL["Razorlash"];
    };
    ["MaraRazorlash"] = {
        Title = AL["Razorlash"];
        Next_Page = "MaraLordVyletongue";
        Next_Title = AL["Lord Vyletongue"];
        Prev_Page = "MaraNoxxion";
        Prev_Title = AL["Noxxion"];
    };
    ["MaraLordVyletongue"] = {
        Title = AL["Lord Vyletongue"];
        Next_Page = "MaraMeshlok";
        Next_Title = AL["Meshlok the Harvester"].." ("..AL["Rare"]..")";
        Prev_Page = "MaraRazorlash";
        Prev_Title = AL["Razorlash"];
    };
    ["MaraMeshlok"] = {
        Title = AL["Meshlok the Harvester"].." ("..AL["Rare"]..")";
        Next_Page = "MaraCelebras";
        Next_Title = AL["Celebras the Cursed"];
        Prev_Page = "MaraLordVyletongue";
        Prev_Title = AL["Lord Vyletongue"];
    };
    ["MaraCelebras"] = {
        Title = AL["Celebras the Cursed"];
        Next_Page = "MaraLandslide";
        Next_Title = AL["Landslide"];
        Prev_Page = "MaraMeshlok";
        Prev_Title = AL["Meshlok the Harvester"].." ("..AL["Rare"]..")";
    };
    ["MaraLandslide"] = {
        Title = AL["Landslide"];
        Next_Page = "MaraTinkererGizlock";
        Next_Title = AL["Tinkerer Gizlock"];
        Prev_Page = "MaraCelebras";
        Prev_Title = AL["Celebras the Cursed"];
    };
    ["MaraTinkererGizlock"] = {
        Title = AL["Tinkerer Gizlock"];
        Next_Page = "MaraRotgrip";
        Next_Title = AL["Rotgrip"];
        Prev_Page = "MaraLandslide";
        Prev_Title = AL["Landslide"];
    };
    ["MaraRotgrip"] = {
        Title = AL["Rotgrip"];
        Next_Page = "MaraPrincessTheradras";
        Next_Title = AL["Princess Theradras"];
        Prev_Page = "MaraTinkererGizlock";
        Prev_Title = AL["Tinkerer Gizlock"];
    };
    ["MaraPrincessTheradras"] = {
        Title = AL["Princess Theradras"];
        Next_Page = "MaraTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "MaraRotgrip";
        Prev_Title = AL["Rotgrip"];
    };
    ["MaraTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "MaraPrincessTheradras";
        Prev_Title = AL["Princess Theradras"];
    };
    ["RFCTaragaman"] = {
        Title = AL["Taragaman the Hungerer"];
        Next_Page = "RFCOggleflint";
        Next_Title = AL["Oggleflint"];
    };
    ["RFCOggleflint"] = {
        Title = AL["Oggleflint"];
        Next_Page = "RFCJergosh";
        Next_Title = AL["Jergosh the Invoker"];
        Prev_Page = "RFCTaragaman";
        Prev_Title = AL["Taragaman the Hungerer"];
    };
    ["RFCJergosh"] = {
        Title = AL["Jergosh the Invoker"];
        Next_Page = "RFCBazzalan";
        Next_Title = AL["Bazzalan"];
        Prev_Page = "RFCOggleflint";
        Prev_Title = AL["Oggleflint"];
    };
    ["RFCBazzalan"] = {
        Title = AL["Bazzalan"];
        Prev_Page = "RFCJergosh";
        Prev_Title = AL["Jergosh the Invoker"];
    };
    ["RFDTutenkash"] = {
        Title = AL["Tuten'kash"];
        Next_Page = "RFDLadyF";
        Next_Title = AL["Lady Falther'ess"].." ("..AL["Scourge Invasion"]..")";
    };
    ["RFDLadyF"] = {
        Title = AL["Lady Falther'ess"].." ("..AL["Scourge Invasion"]..")";
        Next_Page = "RFDPlaguemaw";
        Next_Title = AL["Plaguemaw the Rotting"];
        Prev_Page = "RFDTutenkash";
        Prev_Title = AL["Tuten'kash"];
    };
    ["RFDPlaguemaw"] = {
        Title = AL["Plaguemaw the Rotting"];
        Next_Page = "RFDMordreshFireEye";
        Next_Title = AL["Mordresh Fire Eye"];
        Prev_Page = "RFDLadyF";
        Prev_Title = AL["Lady Falther'ess"].." ("..AL["Scourge Invasion"]..")";
    };
    ["RFDMordreshFireEye"] = {
        Title = AL["Mordresh Fire Eye"];
        Next_Page = "RFDGlutton";
        Next_Title = AL["Glutton"];
        Prev_Page = "RFDPlaguemaw";
        Prev_Title = AL["Plaguemaw the Rotting"];
    };
    ["RFDGlutton"] = {
        Title = AL["Glutton"];
        Next_Page = "RFDRagglesnout";
        Next_Title = AL["Ragglesnout"].." ("..AL["Rare"]..")";
        Prev_Page = "RFDMordreshFireEye";
        Prev_Title = AL["Mordresh Fire Eye"];
    };
    ["RFDRagglesnout"] = {
        Title = AL["Ragglesnout"].." ("..AL["Rare"]..")";
        Next_Page = "RFDAmnennar";
        Next_Title = AL["Amnennar the Coldbringer"];
        Prev_Page = "RFDGlutton";
        Prev_Title = AL["Glutton"];
    };
    ["RFDAmnennar"] = {
        Title = AL["Amnennar the Coldbringer"];
        Next_Page = "RFDTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "RFDRagglesnout";
        Prev_Title = AL["Ragglesnout"].." ("..AL["Rare"]..")";
    };
    ["RFDTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "RFDAmnennar";
        Prev_Title = AL["Amnennar the Coldbringer"];
    };
    ["RFKAggem"] = {
        Title = AL["Aggem Thorncurse"];
        Next_Page = "RFKDeathSpeakerJargba";
        Next_Title = AL["Death Speaker Jargba"];
    };
    ["RFKDeathSpeakerJargba"] = {
        Title = AL["Death Speaker Jargba"];
        Next_Page = "RFKOverlordRamtusk";
        Next_Title = AL["Overlord Ramtusk"];
        Prev_Page = "RFKAggem";
        Prev_Title = AL["Aggem Thorncurse"];
    };
    ["RFKOverlordRamtusk"] = {
        Title = AL["Overlord Ramtusk"];
        Next_Page = "RFKRazorfenSpearhide";
        Next_Title = AL["Razorfen Spearhide"].." ("..AL["Rare"]..")";
        Prev_Page = "RFKDeathSpeakerJargba";
        Prev_Title = AL["Death Speaker Jargba"];
    };
    ["RFKRazorfenSpearhide"] = {
        Title = AL["Razorfen Spearhide"].." ("..AL["Rare"]..")";
        Next_Page = "RFKAgathelos";
        Next_Title = AL["Agathelos the Raging"];
        Prev_Page = "RFKOverlordRamtusk";
        Prev_Title = AL["Overlord Ramtusk"];
    };
    ["RFKAgathelos"] = {
        Title = AL["Agathelos the Raging"];
        Next_Page = "RFKBlindHunter";
        Next_Title = AL["Blind Hunter"].." ("..AL["Rare"]..")";
        Prev_Page = "RFKRazorfenSpearhide";
        Prev_Title = AL["Razorfen Spearhide"].." ("..AL["Rare"]..")";
    };
    ["RFKBlindHunter"] = {
        Title = AL["Blind Hunter"].." ("..AL["Rare"]..")";
        Next_Page = "RFKCharlgaRazorflank";
        Next_Title = AL["Charlga Razorflank"];
        Prev_Page = "RFKAgathelos";
        Prev_Title = AL["Agathelos the Raging"];
    };
    ["RFKCharlgaRazorflank"] = {
        Title = AL["Charlga Razorflank"];
        Next_Page = "RFKEarthcallerHalmgar";
        Next_Title = AL["Earthcaller Halmgar"].." ("..AL["Rare"]..")";
        Prev_Page = "RFKBlindHunter";
        Prev_Title = AL["Blind Hunter"].." ("..AL["Rare"]..")";
    };
    ["RFKEarthcallerHalmgar"] = {
        Title = AL["Earthcaller Halmgar"].." ("..AL["Rare"]..")";
        Next_Page = "RFKTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "RFKCharlgaRazorflank";
        Prev_Title = AL["Charlga Razorflank"];
    };
    ["RFKTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "RFKEarthcallerHalmgar";
        Prev_Title = AL["Earthcaller Halmgar"].." ("..AL["Rare"]..")";
    };
    ["AQ20Kurinnaxx"] = {
        Title = AL["Kurinnaxx"];
        Next_Page = "AQ20Andorov";
        Next_Title = AL["Lieutenant General Andorov"];
    };
    ["AQ20Andorov"] = {
        Title = AL["Lieutenant General Andorov"];
        Next_Page = "AQ20CAPTAIN";
        Next_Title = AtlasLoot_TableNames["AQ20CAPTAIN"][1];
        Prev_Page = "AQ20Kurinnaxx";
        Prev_Title = AL["Kurinnaxx"];
    };
    ["AQ20CAPTAIN"] = {
        Title = AtlasLoot_TableNames["AQ20CAPTAIN"][1];
        Next_Page = "AQ20Rajaxx";
        Next_Title = AL["General Rajaxx"];
        Prev_Page = "AQ20Andorov";
        Prev_Title = AL["Lieutenant General Andorov"];
    };
    ["AQ20Rajaxx"] = {
        Title = AL["General Rajaxx"];
        Next_Page = "AQ20Moam";
        Next_Title = AL["Moam"];
        Prev_Page = "AQ20CAPTAIN";
        Prev_Title = AtlasLoot_TableNames["AQ20CAPTAIN"][1];
    };
    ["AQ20Moam"] = {
        Title = AL["Moam"];
        Next_Page = "AQ20Buru";
        Next_Title = AL["Buru the Gorger"];
        Prev_Page = "AQ20Rajaxx";
        Prev_Title = AL["General Rajaxx"];
    };
    ["AQ20Buru"] = {
        Title = AL["Buru the Gorger"];
        Next_Page = "AQ20Ayamiss";
        Next_Title = AL["Ayamiss the Hunter"];
        Prev_Page = "AQ20Moam";
        Prev_Title = AL["Moam"];
    };
    ["AQ20Ayamiss"] = {
        Title = AL["Ayamiss the Hunter"];
        Next_Page = "AQ20Ossirian";
        Next_Title = AL["Ossirian the Unscarred"];
        Prev_Page = "AQ20Buru";
        Prev_Title = AL["Buru the Gorger"];
    };
    ["AQ20Ossirian"] = {
        Title = AL["Ossirian the Unscarred"];
        Next_Page = "AQ20Trash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "AQ20Ayamiss";
        Prev_Title = AL["Ayamiss the Hunter"];
    };
    ["AQ20Trash"] = {
        Title = AL["Trash Mobs"];
        Next_Page = "AQ20ClassBooks";
        Next_Title = AL["Class Books"];
        Prev_Page = "AQ20Ossirian";
        Prev_Title = AL["Ossirian the Unscarred"];
    };
    ["AQ20ClassBooks"] = {
        Title = AL["Class Books"];
        Next_Page = "AQEnchants";
        Next_Title = AL["AQ Enchants"];
        Prev_Page = "AQ20Trash";
        Prev_Title = AL["Trash Mobs"];
    };
    ["AQEnchants"] = {
        Title = AL["AQ Enchants"];
        Prev_Page = "AQ20ClassBooks";
        Prev_Title = AL["Class Books"];
    };
    ["AQ40Skeram"] = {
        Title = AL["The Prophet Skeram"];
        Next_Page = "AQ40Trio";
        Next_Title = AL["The Bug Family"];
    };
    ["AQ40Trio"] = {
        Title = AL["The Bug Family"];
        Next_Page = "AQ40Sartura";
        Next_Title = AL["Battleguard Sartura"];
        Prev_Page = "AQ40Skeram";
        Prev_Title = AL["The Prophet Skeram"];
    };
    ["AQ40Sartura"] = {
        Title = AL["Battleguard Sartura"];
        Next_Page = "AQ40Fankriss";
        Next_Title = AL["Fankriss the Unyielding"];
        Prev_Page = "AQ40Trio";
        Prev_Title = AL["The Bug Family"];
    };
    ["AQ40Fankriss"] = {
        Title = AL["Fankriss the Unyielding"];
        Next_Page = "AQ40Viscidus";
        Next_Title = AL["Viscidus"];
        Prev_Page = "AQ40Sartura";
        Prev_Title = AL["Battleguard Sartura"];
    };
    ["AQ40Viscidus"] = {
        Title = AL["Viscidus"];
        Next_Page = "AQ40Huhuran";
        Next_Title = AL["Princess Huhuran"];
        Prev_Page = "AQ40Fankriss";
        Prev_Title = AL["Fankriss the Unyielding"];
    };
    ["AQ40Huhuran"] = {
        Title = AL["Princess Huhuran"];
        Next_Page = "AQ40Emperors";
        Next_Title = AL["The Twin Emperors"];
        Prev_Page = "AQ40Viscidus";
        Prev_Title = AL["Viscidus"];
    };
    ["AQ40Emperors"] = {
        Title = AL["The Twin Emperors"];
        Next_Page = "AQ40Ouro";
        Next_Title = AL["Ouro"];
        Prev_Page = "AQ40Huhuran";
        Prev_Title = AL["Princess Huhuran"];
    };
    ["AQ40Ouro"] = {
        Title = AL["Ouro"];
        Next_Page = "AQ40CThun";
        Next_Title = AL["C'Thun"];
        Prev_Page = "AQ40Emperors";
        Prev_Title = AL["The Twin Emperors"];
    };
    ["AQ40CThun"] = {
        Title = AL["C'Thun"];
        Next_Page = "AQ40Trash1";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "AQ40Ouro";
        Prev_Title = AL["Ouro"];
    };
    ["AQ40Trash1"] = {
        Title = AL["Trash Mobs"];
        Next_Page = "AQEnchants";
        Next_Title = AL["AQ Enchants"];
        Prev_Page = "AQ40CThun";
        Prev_Title = AL["C'Thun"];
    };
    ["AQEnchants"] = {
        Title = AL["AQ Enchants"];
        Next_Page = "AQOpening";
        Next_Title = AL["AQ Opening Quest Chain"];
        Prev_Page = "AQ40Trash1";
        Prev_Title = AL["Trash Mobs"];
    };
    ["AQOpening"] = {
        Title = AL["AQ Opening Quest Chain"];
        Prev_Page = "AQEnchants";
        Prev_Title = AL["AQ Enchants"];
    };
    ["WCLordCobrahn"] = {
        Title = AL["Lord Cobrahn"];
        Next_Page = "WCLadyAnacondra";
        Next_Title = AL["Lady Anacondra"];
    };
    ["WCLadyAnacondra"] = {
        Title = AL["Lady Anacondra"];
        Next_Page = "WCKresh";
        Next_Title = AL["Kresh"];
        Prev_Page = "WCLordCobrahn";
        Prev_Title = AL["Lord Cobrahn"];
    };
    ["WCKresh"] = {
        Title = AL["Kresh"];
        Next_Page = "WCLordPythas";
        Next_Title = AL["Lord Pythas"];
        Prev_Page = "WCLadyAnacondra";
        Prev_Title = AL["Lady Anacondra"];
    };
    ["WCLordPythas"] = {
        Title = AL["Lord Pythas"];
        Next_Page = "WCSkum";
        Next_Title = AL["Skum"];
        Prev_Page = "WCKresh";
        Prev_Title = AL["Kresh"];
    };
    ["WCSkum"] = {
        Title = AL["Skum"];
        Next_Page = "WCLordSerpentis";
        Next_Title = AL["Lord Serpentis"];
        Prev_Page = "WCLordPythas";
        Prev_Title = AL["Lord Pythas"];
    };
    ["WCLordSerpentis"] = {
        Title = AL["Lord Serpentis"];
        Next_Page = "WCVerdan";
        Next_Title = AL["Verdan the Everliving"];
        Prev_Page = "WCSkum";
        Prev_Title = AL["Skum"];
    };
    ["WCVerdan"] = {
        Title = AL["Verdan the Everliving"];
        Next_Page = "WCMutanus";
        Next_Title = AL["Mutanus the Devourer"];
        Prev_Page = "WCLordSerpentis";
        Prev_Title = AL["Lord Serpentis"];
    };
    ["WCMutanus"] = {
        Title = AL["Mutanus the Devourer"];
        Next_Page = "WCDeviateFaerieDragon";
        Next_Title = AL["Deviate Faerie Dragon"].." ("..AL["Rare"]..")";
        Prev_Page = "WCVerdan";
        Prev_Title = AL["Verdan the Everliving"];
    };
    ["WCDeviateFaerieDragon"] = {
        Title = AL["Deviate Faerie Dragon"].." ("..AL["Rare"]..")";
        Next_Page = "WCTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "WCMutanus";
        Prev_Title = AL["Mutanus the Devourer"];
    };
    ["WCTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "WCDeviateFaerieDragon";
        Prev_Title = AL["Deviate Faerie Dragon"].." ("..AL["Rare"]..")";
    };
    ["ZFAntusul"] = {
        Title = AL["Antu'sul"];
        Next_Page = "ZFWitchDoctorZumrah";
        Next_Title = AL["Witch Doctor Zum'rah"];
    };
    ["ZFWitchDoctorZumrah"] = {
        Title = AL["Witch Doctor Zum'rah"];
        Next_Page = "ZFSezzziz";
        Next_Title = AL["Shadowpriest Sezz'ziz"];
        Prev_Page = "ZFAntusul";
        Prev_Title = AL["Antu'sul"];
    };
    ["ZFSezzziz"] = {
        Title = AL["Shadowpriest Sezz'ziz"];
        Next_Page = "ZFDustwraith";
        Next_Title = AL["Dustwraith"].." ("..AL["Rare"]..")";
        Prev_Page = "ZFWitchDoctorZumrah";
        Prev_Title = AL["Witch Doctor Zum'rah"];
    };
    ["ZFDustwraith"] = {
        Title = AL["Dustwraith"].." ("..AL["Rare"]..")";
        Next_Page = "ZFZerillis";
        Next_Title = AL["Zerillis"].." ("..AL["Rare"]..")";
        Prev_Page = "ZFSezzziz";
        Prev_Title = AL["Shadowpriest Sezz'ziz"];
    };
    ["ZFZerillis"] = {
        Title = AL["Zerillis"].." ("..AL["Rare"]..")";
        Next_Page = "ZFGahzrilla";
        Next_Title = AL["Gahz'rilla"];
        Prev_Page = "ZFDustwraith";
        Prev_Title = AL["Dustwraith"].." ("..AL["Rare"]..")";
    };
    ["ZFGahzrilla"] = {
        Title = AL["Gahz'rilla"];
        Next_Page = "ZFChiefUkorzSandscalp";
        Next_Title = AL["Chief Ukorz Sandscalp"];
        Prev_Page = "ZFZerillis";
        Prev_Title = AL["Zerillis"].." ("..AL["Rare"]..")";
    };
    ["ZFChiefUkorzSandscalp"] = {
        Title = AL["Chief Ukorz Sandscalp"];
        Next_Page = "ZFTrash";
        Next_Title = AL["Trash Mobs"];
        Prev_Page = "ZFGahzrilla";
        Prev_Title = AL["Gahz'rilla"];
    };
    ["ZFTrash"] = {
        Title = AL["Trash Mobs"];
        Prev_Page = "ZFChiefUkorzSandscalp";
        Prev_Title = AL["Chief Ukorz Sandscalp"];
    };
    ["AAzuregos"] = {
        Title = AL["Azuregos"];
        Next_Page = "DEmeriss";
        Next_Title = AL["Emeriss"];
    };
    ["DEmeriss"] = {
        Title = AL["Emeriss"];
        Next_Page = "DLethon";
        Next_Title = AL["Lethon"];
        Prev_Page = "AAzuregos";
        Prev_Title = AL["Azuregos"];
    };
    ["DLethon"] = {
        Title = AL["Lethon"];
        Next_Page = "DTaerar";
        Next_Title = AL["Taerar"];
        Prev_Page = "DEmeriss";
        Prev_Title = AL["Emeriss"];
    };
    ["DTaerar"] = {
        Title = AL["Taerar"];
        Next_Page = "DYsondre";
        Next_Title = AL["Ysondre"];
        Prev_Page = "DLethon";
        Prev_Title = AL["Lethon"];
    };
    ["DYsondre"] = {
        Title = AL["Ysondre"];
        Next_Page = "KKazzak";
        Next_Title = AL["Lord Kazzak"];
        Prev_Page = "DTaerar";
        Prev_Title = AL["Taerar"];
    };
    ["KKazzak"] = {
        Title = AL["Lord Kazzak"];
        Next_Page = "Turtlhu";
        Next_Title = "Turtlhu, the Black Turtle of Doom";
        Prev_Page = "DYsondre";
        Prev_Title = AL["Ysondre"];
    };
    ["Turtlhu"] = {
        Title = "Turtlhu, the Black Turtle of Doom";
        Next_Page = "Nerubian";
        Next_Title = "Nerubian Overseer";
        Prev_Page = "KKazzak";
        Prev_Title = AL["Lord Kazzak"];
    };
    ["Nerubian"] = {
        Title = "Nerubian Overseer";
        Next_Page = "Reaver";
        Next_Title = "Dark Reaver of Karazhan";
        Prev_Page = "Turtlhu";
        Prev_Title = "Turtlhu, the Black Turtle of Doom";
    };
    ["Reaver"] = {
        Title = "Dark Reaver of Karazhan";
        Next_Page = "Ostarius";
        Next_Title = "Ostarius";
        Prev_Page = "Nerubian";
        Prev_Title = "Nerubian Overseer";
    };
    ["Ostarius"] = {
        Title = "Ostarius";
        Next_Page = "Concavius";
        Next_Title = "Concavius";
        Prev_Page = "Reaver";
        Prev_Title = "Dark Reaver of Karazhan";
    };
    ["Concavius"] = {
        Title = "Concavius";
		Next_Page = "CowKing";
		Next_Title = "The Cow King";
        Prev_Page = "Ostarius";
        Prev_Title = "Ostarius";
    };
	["CowKing"] = {
        Title = "There Is No Cow Level";
        Prev_Page = "Concavius";
        Prev_Title = "Concavius";
    };
    ["Tarangos"] = {
        Title = "Tarangos The Dampener";
        Next_Page = "Kargron";
        Next_Title = "Blademaster Kargron";
    };
    ["Kargron"] = {
        Title = "Blademaster Kargron";
        Next_Page = "Xalvic";
        Next_Title = "Xalvic Blackclaw";
        Prev_Page = "Tarangos";
        Prev_Title = "Tarangos The Dampener";
    };
    ["Xalvic"] = {
        Title = "Xalvic Blackclaw";
        Next_Page = "Mallon";
        Next_Title = "Mallon The Moontouched";
        Prev_Page = "Kargron";
        Prev_Title = "Blademaster Kargron";
    };
    ["Mallon"] = {
        Title = "Mallon The Moontouched";
        Next_Page = "Grugthok";
        Next_Title = "Grug'thok the Seer";
        Prev_Page = "Xalvic";
        Prev_Title = "Xalvic Blackclaw";
    };
    ["Grugthok"] = {
        Title = "Grug'thok the Seer";
        Next_Page = "WanderingKnight";
        Next_Title = "The Wandering Knight";
        Prev_Page = "Mallon";
        Prev_Title = "Mallon The Moontouched";
    };
    ["WanderingKnight"] = {
        Title = "The Wandering Knight";
        Next_Page = "CrusaderLarsarius";
        Next_Title = "Crusader Larsarius The Scarlet Crusade";
        Prev_Page = "Grugthok";
        Prev_Title = "Grug'thok the Seer";
    };
    ["CrusaderLarsarius"] = {
        Title = "Crusader Larsarius The Scarlet Crusade";
        Next_Page = "Zareth";
        Next_Title = "Zareth Terrorblade Demon Hunter";
        Prev_Page = "WanderingKnight";
        Prev_Title = "The Wandering Knight";
    };
    ["Zareth"] = {
        Title = "Zareth Terrorblade Demon Hunter";
        Next_Page = "Jalakar";
        Next_Title = "Jal'akar Dire Troll";
        Prev_Page = "CrusaderLarsarius";
        Prev_Title = "Crusader Larsarius The Scarlet Crusade";
    };
    ["Jalakar"] = {
        Title = "Jal'akar Dire Troll";
        Next_Page = "Ashbeard";
        Next_Title = "Explorer Ashbeard";
        Prev_Page = "Zareth";
        Prev_Title = "Zareth Terrorblade Demon Hunter";
    };
    ["Ashbeard"] = {
        Title = "Explorer Ashbeard";
        Next_Page = "AdmiralBareanWestwind";
        Next_Title = "Admiral Barean Westwind";
        Prev_Page = "Jalakar";
        Prev_Title = "Jal'akar Dire Troll";
    };
    ["AdmiralBareanWestwind"] = {
        Title = "Admiral Barean Westwind";
        Prev_Page = "Ashbeard";
        Prev_Title = "Explorer Ashbeard";
    };


    --WoW Factions
    ["Argent1"] = {
        Title = AL["Argent Dawn"] .. ": " .. AL["Token Hand-Ins"];
        Next_Page = "Argent2";
        Next_Title = AL["Argent Dawn"] .. ": " .. AL["Friendly"] .. "-" .. AL["Exalted"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Argent2"] = {
        Title = AL["Argent Dawn"] .. ": " .. AL["Friendly"] .. "-" .. AL["Honored"];
        Prev_Page = "Argent1";
        Prev_Title = AL["Argent Dawn"] .. ": " .. AL["Token Hand-Ins"];
        Next_Page = "Argent3";
        Next_Title = AL["Argent Dawn"] .. ": " .. AL["Revered"] .. "-" .. AL["Exalted"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Argent3"] = {
        Title = AL["Argent Dawn"] .. ": " .. AL["Revered"] .. "-" .. AL["Exalted"];
        Prev_Page = "Argent2";
        Prev_Title = AL["Argent Dawn"] .. ": " .. AL["Friendly"] .. "-" .. AL["Honored"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Bloodsail1"] = {
        Title = AL["Bloodsail Buccaneers"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
	["Warderns1"] = {
		Title = "Wardens of Time";
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["AQBroodRings"] = {
        Title = AL["Brood of Nozdormu"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Cenarion1"] = {
        Title = AL["Cenarion Circle"] .. ": " .. AL["Friendly"];
        Next_Page = "Cenarion2";
        Next_Title = AL["Cenarion Circle"] .. ": " .. AL["Honored"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Cenarion2"] = {
        Title = AL["Cenarion Circle"] .. ": " .. AL["Honored"];
        Next_Page = "Cenarion3";
        Next_Title = AL["Cenarion Circle"] .. ": " .. AL["Revered"];
        Prev_Page = "Cenarion1";
        Prev_Title = AL["Cenarion Circle"] .. ": " .. AL["Friendly"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Cenarion3"] = {
        Title = AL["Cenarion Circle"] .. ": " .. AL["Revered"];
        Next_Page = "Cenarion4";
        Next_Title = AL["Cenarion Circle"] .. ": " .. AL["Exalted"];
        Prev_Page = "Cenarion2";
        Prev_Title = AL["Cenarion Circle"] .. ": " .. AL["Honored"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Cenarion4"] = {
        Title = AL["Cenarion Circle"] .. ": " .. AL["Exalted"];
        Prev_Page = "Cenarion3";
        Prev_Title = AL["Cenarion Circle"] .. ": " .. AL["Revered"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Darkmoon"] = {
        Title = AL["Darkmoon Faire"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Defilers"] = {
        Title = AL["The Defilers"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Frostwolf1"] = {
        Title = AL["Frostwolf Clan"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["GelkisClan1"] = {
        Title = AL["Gelkis Clan Centaur"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["WaterLords1"] = {
        Title = AL["Hydraxian Waterlords"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["LeagueofArathor"] = {
        Title = AL["The League of Arathor"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Ironforge"] = {
        Title = AL["Ironforge"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Darnassus"] = {
        Title = AL["Darnassus"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Stormwind"] = {
        Title = AL["Stormwind"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["GnomereganExiles"] = {
        Title = AL["Gnomeregan Exiles"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
	["DarkspearTrolls"] = {
		Title = AL["Darkspear Trolls"];
		Back_Page = "REPMENU";
		Back_Title = AL["Factions"];
	};
    ["DurotarLaborUnion"] = {
        Title = AL["Durotar Labor Union"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Undercity"] = {
        Title = AL["Undercity"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Orgrimmar"] = {
        Title = AL["Orgrimmar"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["ThunderBluff"] = {
        Title = AL["Thunder Bluff"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
	["Dalaran"] = {
        Title = AL["Dalaran"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Helf"] = {
        Title = AL["Silvermoon Remnant"];
        Next_Page = "Helf2";
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Helf2"] = {
        Title = AL["Silvermoon Remnant"];
        Next_Page = "Helf3";
        Prev_Page = "Helf";
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Helf3"] = {
        Title = AL["Silvermoon Remnant"];
        Prev_Page = "Helf2";
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Revantusk"] = {
        Title = AL["Revantusk Trolls"];
        Next_Page = "Revantusk2";
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Revantusk2"] = {
        Title = AL["Revantusk Trolls"];
        Next_Page = "Revantusk3";
        Prev_Page = "Revantusk";
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Revantusk3"] = {
        Title = AL["Revantusk Trolls"];
        Prev_Page = "Revantusk2";
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["MagramClan1"] = {
        Title = AL["Magram Clan Centaur"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Stormpike1"] = {
        Title = AL["Stormpike Guard"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Thorium1"] = {
        Title = AL["Thorium Brotherhood"] .. ": " .. AL["Friendly"] .. "/" .. AL["Honored"];
        Next_Page = "Thorium2";
        Next_Title = AL["Thorium Brotherhood"] .. ": " .. AL["Revered"] .. "/" .. AL["Exalted"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Thorium2"] = {
        Title = AL["Thorium Brotherhood"] .. ": " .. AL["Revered"] .. "/" .. AL["Exalted"];
        Prev_Page = "Thorium1";
        Prev_Title = AL["Thorium Brotherhood"] .. ": " .. AL["Friendly"] .. "/" .. AL["Honored"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Timbermaw"] = {
        Title = AL["Timbermaw Hold"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Wintersaber1"] = {
        Title = AL["Wintersaber Trainers"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Zandalar1"] = {
        Title = AL["Zandalar Tribe"] .. ": " .. AL["Friendly"] .. "/" .. AL["Honored"];
        Next_Page = "Zandalar2";
        Next_Title = AL["Zandalar Tribe"] .. ": " .. AL["Revered"] .. "/" .. AL["Exalted"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["Zandalar2"] = {
        Title = AL["Zandalar Tribe"] .. ": " .. AL["Revered"] .. "/" .. AL["Exalted"];
        Prev_Page = "Zandalar1";
        Prev_Title = AL["Zandalar Tribe"] .. ": " .. AL["Friendly"] .. "/" .. AL["Honored"];
        Back_Page = "REPMENU";
        Back_Title = AL["Factions"];
    };
    ["BRRepFriendly"] = {
        Title = "Blood Ring Friendly Rewards";
        Back_Page = "BRRepMenu";
        Next_Page = "BRRepHonored";
    };
    ["BRRepHonored"] = {
        Title = "Blood Ring Honored Rewards";
        Back_Page = "BRRepMenu";
        Next_Page = "BRRepRevered";
        Prev_Page = "BRRepFriendly";
    };
    ["BRRepRevered"] = {
        Title = "Blood Ring Revered Rewards";
        Back_Page = "BRRepMenu";
        Next_Page = "BRRepExalted";
        Prev_Page = "BRRepHonored";
    };
    ["BRRepExalted"] = {
        Title = "Blood Ring Exalted Rewards";
        Back_Page = "BRRepMenu";
        Prev_Page = "BRRepRevered";
    };
    ["ABRepFriendly2029"] = {
        Title = "AB 20-29 Friendly Rewards";
        Back_Page = "ABRepMenu";
        Next_Page = "ABRepFriendly3039";
    };
    ["ABRepFriendly3039"] = {
        Title = "AB 30-39 Friendly Rewards";
        Back_Page = "ABRepMenu";
        Next_Page = "ABRepFriendly4049";
        Prev_Page = "ABRepFriendly2029";
    };
    ["ABRepFriendly4049"] = {
        Title = "AB 40-49 Friendly Rewards";
        Back_Page = "ABRepMenu";
        Next_Page = "ABRepFriendly5059";
        Prev_Page = "ABRepFriendly3039";
    };
    ["ABRepFriendly5059"] = {
        Title = "AB 50-59 Friendly Rewards";
        Back_Page = "ABRepMenu";
        Prev_Page = "ABRepFriendly4049";
    };
    ["ABRepHonored2029"] = {
        Title = "AB 20-29 Honored Rewards";
        Back_Page = "ABRepMenu";
        Next_Page = "ABRepHonored3039";
    };
    ["ABRepHonored3039"] = {
        Title = "AB 30-39 Honored Rewards";
        Back_Page = "ABRepMenu";
        Next_Page = "ABRepHonored4049";
        Prev_Page = "ABRepHonored2029";
    };
    ["ABRepHonored4049"] = {
        Title = "AB 40-49 Honored Rewards";
        Back_Page = "ABRepMenu";
        Next_Page = "ABRepHonored5059";
        Prev_Page = "ABRepHonored3039";
    };
    ["ABRepHonored5059"] = {
        Title = "AB 50-59 Honored Rewards";
        Back_Page = "ABRepMenu";
        Prev_Page = "ABRepHonored4049";
    };
    ["ABRepRevered2029"] = {
        Title = "AB 20-29 Revered Rewards";
        Back_Page = "ABRepMenu";
        Next_Page = "ABRepRevered3039";
    };
    ["ABRepRevered3039"] = {
        Title = "AB 30-39 Revered Rewards";
        Back_Page = "ABRepMenu";
        Next_Page = "ABRepRevered4049";
        Prev_Page = "ABRepRevered2029";
    };
    ["ABRepRevered4049"] = {
        Title = "AB 40-49 Revered Rewards";
        Back_Page = "ABRepMenu";
        Next_Page = "ABRepRevered5059";
        Prev_Page = "ABRepRevered3039";
    };
    ["ABRepRevered5059"] = {
        Title = "AB 50-59 Revered Rewards";
        Back_Page = "ABRepMenu";
        Prev_Page = "ABRepRevered4049";
    };
    ["ABRepExalted"] = {
        Title = "AB Exalted Rewards";
        Back_Page = "ABRepMenu";
    };
    ["AVRepFriendly"] = {
        Title = "AV Friendly Rewards";
        Back_Page = "AVRepMenu";
        Next_Page = "AVRepHonored";
    };
    ["AVRepHonored"] = {
        Title = "AV Honored Rewards";
        Back_Page = "AVRepMenu";
        Next_Page = "AVRepRevered";
        Prev_Page = "AVRepFriendly";
    };
    ["AVRepRevered"] = {
        Title = "AV Revered Rewards";
        Back_Page = "AVRepMenu";
        Next_Page = "AVRepExalted";
        Prev_Page = "AVRepHonored";
    };
    ["AVRepExalted"] = {
        Title = "AV Exalted Rewards";
        Back_Page = "AVRepMenu";
        Prev_Page = "AVRepRevered";
    };
    ["WSGRepFriendly2029"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 20-29 Friendly Rewards";
        Next_Page = "WSGRepFriendly3039";
    };
    ["WSGRepFriendly3039"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 30-39 Friendly Rewards";
        Next_Page = "WSGRepFriendly4049";
        Prev_Page = "WSGRepFriendly2029";
    };
    ["WSGRepFriendly4049"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 40-49 Friendly Rewards";
        Prev_Page = "WSGRepFriendly3039";
    };
    ["WSGRepHonored1019"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 10-19 Honored Rewards";
        Next_Page = "WSGRepHonored2029";
    };
    ["WSGRepHonored2029"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 20-29 Honored Rewards";
        Next_Page = "WSGRepHonored3039";
        Prev_Page = "WSGRepHonored1019";
    };
    ["WSGRepHonored3039"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 30-39 Honored Rewards";
        Next_Page = "WSGRepHonored4049";
        Prev_Page = "WSGRepHonored2029";
    };
    ["WSGRepHonored4049"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 40-49 Honored Rewards";
        Next_Page = "WSGRepHonored5059";
        Prev_Page = "WSGRepHonored3039";
    };
    ["WSGRepHonored5059"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 50-59 Honored Rewards";
        Prev_Page = "WSGRepHonored4049";
    };
    ["WSGRepRevered1019"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 10-19 Revered Rewards";
        Next_Page = "WSGRepRevered2029";
    };
    ["WSGRepRevered2029"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 20-29 Revered Rewards";
        Next_Page = "WSGRepRevered3039";
        Prev_Page = "WSGRepRevered1019";
    };
    ["WSGRepRevered3039"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 30-39 Revered Rewards";
        Next_Page = "WSGRepRevered4049";
        Prev_Page = "WSGRepRevered2029";
    };
    ["WSGRepRevered4049"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 40-49 Revered Rewards";
        Next_Page = "WSGRepRevered5059";
        Prev_Page = "WSGRepRevered3039";
    };
    ["WSGRepRevered5059"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 50-59 Revered Rewards";
        Prev_Page = "WSGRepRevered4049";
    };
    ["WSGRepExalted4049"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 40-49 Exalted Rewards";
        Next_Page = "WSGRepExalted5059";
    };
    ["WSGRepExalted5059"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 50-59 Exalted Rewards";
        Next_Page = "WSGRepExalted60";
        Prev_Page = "WSGRepExalted4049";
    };
    ["WSGRepExalted60"] = {
        Back_Page = "WSGRepMenu";
        Title = "WSG 60 Exalted Rewards";
        Prev_Page = "WSGRepExalted5059";
    };
    ["PvP60Accessories1"] = {
        Title = AL["PvP Trinkets"];
        Next_Page = "PvP60Accessories2";
        Next_Title = AtlasLoot_TableNames["PvP60Accessories2"][1];
        Back_Page = "PVPMENU";
        Back_Title = AL["PvP Rewards"];
    };
    ["PvP60Accessories2"] = {
        Title = AtlasLoot_TableNames["PvP60Accessories2"][1];
        Next_Page = "PvP60Accessories3";
        Next_Title = AtlasLoot_TableNames["PvP60Accessories3"][1];
        Prev_Page = "PvP60Accessories1";
        Prev_Title = AL["PvP Accessories"] .. ": " .. AL["Level 60"];
        Back_Page = "PVPMENU";
        Back_Title = AL["PvP Rewards"];
    };
    ["PvP60Accessories3"] = {
        Title = AtlasLoot_TableNames["PvP60Accessories3"][1];
        Prev_Page = "PvP60Accessories2";
        Prev_Title = AtlasLoot_TableNames["PvP60Accessories2"][1];
        Back_Page = "PVPMENU";
        Back_Title = AL["PvP Rewards"];
    };
    ["PVPWeapons1"] = {
        Title = AL["Rank 14 Weapons"];
        Next_Page = "PVPWeapons2";
        Next_Title = AL["Rank 14 Weapons"];
        Back_Page = "PVPMENU";
        Back_Title = AL["PvP Rewards"];
    };
    ["PVPWeapons2"] = {
        Title = AL["Rank 14 Weapons"];
        Prev_Page = "PVPWeapons1";
        Prev_Title = AL["Rank 14 Weapons"];
        Back_Page = "PVPMENU";
        Back_Title = AL["PvP Rewards"];
    };
    ["PVPDruid"] = {
        Title = AL["Druid"];
        Back_Page = "PVPSET";
        Back_Title = AL["PvP Armor Sets"];
    };
    ["PVPHunter"] = {
        Title = AL["Hunter"];
        Back_Page = "PVPSET";
        Back_Title = AL["PvP Armor Sets"];
    };
    ["PVPMage"] = {
        Title = AL["Mage"];
        Back_Page = "PVPSET";
        Back_Title = AL["PvP Armor Sets"];
    };
    ["PVPPaladin"] = {
        Title = AL["Paladin"];
        Back_Page = "PVPSET";
        Back_Title = AL["PvP Armor Sets"];
    };
    ["PVPPriest"] = {
        Title = AL["Priest"];
        Back_Page = "PVPSET";
        Back_Title = AL["PvP Armor Sets"];
    };
    ["PVPRogue"] = {
        Title = AL["Rogue"];
        Back_Page = "PVPSET";
        Back_Title = AL["PvP Armor Sets"];
    };
    ["PVPShaman"] = {
        Title = AL["Shaman"];
        Back_Page = "PVPSET";
        Back_Title = AL["PvP Armor Sets"];
    };
    ["PVPWarlock"] = {
        Title = AL["Warlock"];
        Back_Page = "PVPSET";
        Back_Title = AL["PvP Armor Sets"];
    };
    ["PVPWarrior"] = {
        Title = AL["Warrior"];
        Back_Page = "PVPSET";
        Back_Title = AL["PvP Armor Sets"];
    };
    ["T0Druid"] = {
        Title = AL["Druid"];
        Back_Page = "T0SET";
        Back_Title = AL["Dungeon 1/2 Sets"];
    };
    ["T0Hunter"] = {
        Title = AL["Hunter"];
        Back_Page = "T0SET";
        Back_Title = AL["Dungeon 1/2 Sets"];
    };
    ["T0Mage"] = {
        Title = AL["Mage"];
        Back_Page = "T0SET";
        Back_Title = AL["Dungeon 1/2 Sets"];
    };
    ["T0Paladin"] = {
        Title = AL["Paladin"];
        Back_Page = "T0SET";
        Back_Title = AL["Dungeon 1/2 Sets"];
    };
    ["T0Priest"] = {
        Title = AL["Priest"];
        Back_Page = "T0SET";
        Back_Title = AL["Dungeon 1/2 Sets"];
    };
    ["T0Rogue"] = {
        Title = AL["Rogue"];
        Back_Page = "T0SET";
        Back_Title = AL["Dungeon 1/2 Sets"];
    };
    ["T0Shaman"] = {
        Title = AL["Shaman"];
        Back_Page = "T0SET";
        Back_Title = AL["Dungeon 1/2 Sets"];
    };
    ["T0Warlock"] = {
        Title = AL["Warlock"];
        Back_Page = "T0SET";
        Back_Title = AL["Dungeon 1/2 Sets"];
    };
    ["T0Warrior"] = {
        Title = AL["Warrior"];
        Back_Page = "T0SET";
        Back_Title = AL["Dungeon 1/2 Sets"];
    };
    ["T1Druid"] = {
        Title = AL["Druid"];
        Back_Page = "T1SET";
        Back_Title = AL["Tier 1 Sets"];
    };
    ["T1Hunter"] = {
        Title = AL["Hunter"];
        Back_Page = "T1SET";
        Back_Title = AL["Tier 1 Sets"];
    };
    ["T1Mage"] = {
        Title = AL["Mage"];
        Back_Page = "T1SET";
        Back_Title = AL["Tier 1 Sets"];
    };
    ["T1Paladin"] = {
        Title = AL["Paladin"];
        Back_Page = "T1SET";
        Back_Title = AL["Tier 1 Sets"];
    };
    ["T1Priest"] = {
        Title = AL["Priest"];
        Back_Page = "T1SET";
        Back_Title = AL["Tier 1 Sets"];
    };
    ["T1Rogue"] = {
        Title = AL["Rogue"];
        Back_Page = "T1SET";
        Back_Title = AL["Tier 1 Sets"];
    };
    ["T1Shaman"] = {
        Title = AL["Shaman"];
        Back_Page = "T1SET";
        Back_Title = AL["Tier 1 Sets"];
    };
    ["T1Warlock"] = {
        Title = AL["Warlock"];
        Back_Page = "T1SET";
        Back_Title = AL["Tier 1 Sets"];
    };
    ["T1Warrior"] = {
        Title = AL["Warrior"];
        Back_Page = "T1SET";
        Back_Title = AL["Tier 1 Sets"];
    };
    ["T2Druid"] = {
        Title = AL["Druid"];
        Back_Page = "T2SET";
        Back_Title = AL["Tier 2 Sets"];
    };
    ["T2Hunter"] = {
        Title = AL["Hunter"];
        Back_Page = "T2SET";
        Back_Title = AL["Tier 2 Sets"];
    };
    ["T2Mage"] = {
        Title = AL["Mage"];
        Back_Page = "T2SET";
        Back_Title = AL["Tier 2 Sets"];
    };
    ["T2Paladin"] = {
        Title = AL["Paladin"];
        Back_Page = "T2SET";
        Back_Title = AL["Tier 2 Sets"];
    };
    ["T2Priest"] = {
        Title = AL["Priest"];
        Back_Page = "T2SET";
        Back_Title = AL["Tier 2 Sets"];
    };
    ["T2Rogue"] = {
        Title = AL["Rogue"];
        Back_Page = "T2SET";
        Back_Title = AL["Tier 2 Sets"];
    };
    ["T2Shaman"] = {
        Title = AL["Shaman"];
        Back_Page = "T2SET";
        Back_Title = AL["Tier 2 Sets"];
    };
    ["T2Warlock"] = {
        Title = AL["Warlock"];
        Back_Page = "T2SET";
        Back_Title = AL["Tier 2 Sets"];
    };
    ["T2Warrior"] = {
        Title = AL["Warrior"];
        Back_Page = "T2SET";
        Back_Title = AL["Tier 2 Sets"];
    };
    ["T3Druid"] = {
        Title = AL["Druid"];
        Back_Page = "T3SET";
        Back_Title = AL["Tier 3 Sets"];
    };
    ["T3Hunter"] = {
        Title = AL["Hunter"];
        Back_Page = "T3SET";
        Back_Title = AL["Tier 3 Sets"];
    };
    ["T3Mage"] = {
        Title = AL["Mage"];
        Back_Page = "T3SET";
        Back_Title = AL["Tier 3 Sets"];
    };
    ["T3Paladin"] = {
        Title = AL["Paladin"];
        Back_Page = "T3SET";
        Back_Title = AL["Tier 3 Sets"];
    };
    ["T3Priest"] = {
        Title = AL["Priest"];
        Back_Page = "T3SET";
        Back_Title = AL["Tier 3 Sets"];
    };
    ["T3Rogue"] = {
        Title = AL["Rogue"];
        Back_Page = "T3SET";
        Back_Title = AL["Tier 3 Sets"];
    };
    ["T3Shaman"] = {
        Title = AL["Shaman"];
        Back_Page = "T3SET";
        Back_Title = AL["Tier 3 Sets"];
    };
    ["T3Warlock"] = {
        Title = AL["Warlock"];
        Back_Page = "T3SET";
        Back_Title = AL["Tier 3 Sets"];
    };
    ["T3Warrior"] = {
        Title = AL["Warrior"];
        Back_Page = "T3SET";
        Back_Title = AL["Tier 3 Sets"];
    };
    ["AQ40Druid"] = {
        Title = AL["Druid"];
        Back_Page = "AQ40SET";
        Back_Title = AL["Temple of Ahn'Qiraj Sets"];
    };
    ["AQ40Hunter"] = {
        Title = AL["Hunter"];
        Back_Page = "AQ40SET";
        Back_Title = AL["Temple of Ahn'Qiraj Sets"];
    };
    ["AQ40Mage"] = {
        Title = AL["Mage"];
        Back_Page = "AQ40SET";
        Back_Title = AL["Temple of Ahn'Qiraj Sets"];
    };
    ["AQ40Paladin"] = {
        Title = AL["Paladin"];
        Back_Page = "AQ40SET";
        Back_Title = AL["Temple of Ahn'Qiraj Sets"];
    };
    ["AQ40Priest"] = {
        Title = AL["Priest"];
        Back_Page = "AQ40SET";
        Back_Title = AL["Temple of Ahn'Qiraj Sets"];
    };
    ["AQ40Rogue"] = {
        Title = AL["Rogue"];
        Back_Page = "AQ40SET";
        Back_Title = AL["Temple of Ahn'Qiraj Sets"];
    };
    ["AQ40Shaman"] = {
        Title = AL["Shaman"];
        Back_Page = "AQ40SET";
        Back_Title = AL["Temple of Ahn'Qiraj Sets"];
    };
    ["AQ40Warlock"] = {
        Title = AL["Warlock"];
        Back_Page = "AQ40SET";
        Back_Title = AL["Temple of Ahn'Qiraj Sets"];
    };
    ["AQ40Warrior"] = {
        Title = AL["Warrior"];
        Back_Page = "AQ40SET";
        Back_Title = AL["Temple of Ahn'Qiraj Sets"];
    };
    ["AQ20Druid"] = {
        Title = AL["Druid"];
        Back_Page = "AQ20SET";
        Back_Title = AL["Ruins of Ahn'Qiraj Sets"];
    };
    ["AQ20Hunter"] = {
        Title = AL["Hunter"];
        Back_Page = "AQ20SET";
        Back_Title = AL["Ruins of Ahn'Qiraj Sets"];
    };
    ["AQ20Mage"] = {
        Title = AL["Mage"];
        Back_Page = "AQ20SET";
        Back_Title = AL["Ruins of Ahn'Qiraj Sets"];
    };
    ["AQ20Paladin"] = {
        Title = AL["Paladin"];
        Back_Page = "AQ20SET";
        Back_Title = AL["Ruins of Ahn'Qiraj Sets"];
    };
    ["AQ20Priest"] = {
        Title = AL["Priest"];
        Back_Page = "AQ20SET";
        Back_Title = AL["Ruins of Ahn'Qiraj Sets"];
    };
    ["AQ20Rogue"] = {
        Title = AL["Rogue"];
        Back_Page = "AQ20SET";
        Back_Title = AL["Ruins of Ahn'Qiraj Sets"];
    };
    ["AQ20Shaman"] = {
        Title = AL["Shaman"];
        Back_Page = "AQ20SET";
        Back_Title = AL["Ruins of Ahn'Qiraj Sets"];
    };
    ["AQ20Warlock"] = {
        Title = AL["Warlock"];
        Back_Page = "AQ20SET";
        Back_Title = AL["Ruins of Ahn'Qiraj Sets"];
    };
    ["AQ20Warrior"] = {
        Title = AL["Warrior"];
        Back_Page = "AQ20SET";
        Back_Title = AL["Ruins of Ahn'Qiraj Sets"];
    };
    ["ZGDruid"] = {
        Title = AL["Druid"];
        Back_Page = "ZGSET";
        Back_Title = AL["Zul'Gurub Sets"];
    };
    ["ZGHunter"] = {
        Title = AL["Hunter"];
        Back_Page = "ZGSET";
        Back_Title = AL["Zul'Gurub Sets"];
    };
    ["ZGMage"] = {
        Title = AL["Mage"];
        Back_Page = "ZGSET";
        Back_Title = AL["Zul'Gurub Sets"];
    };
    ["ZGPaladin"] = {
        Title = AL["Paladin"];
        Back_Page = "ZGSET";
        Back_Title = AL["Zul'Gurub Sets"];
    };
    ["ZGPriest"] = {
        Title = AL["Priest"];
        Back_Page = "ZGSET";
        Back_Title = AL["Zul'Gurub Sets"];
    };
    ["ZGRogue"] = {
        Title = AL["Rogue"];
        Back_Page = "ZGSET";
        Back_Title = AL["Zul'Gurub Sets"];
    };
    ["ZGShaman"] = {
        Title = AL["Shaman"];
        Back_Page = "ZGSET";
        Back_Title = AL["Zul'Gurub Sets"];
    };
    ["ZGWarlock"] = {
        Title = AL["Warlock"];
        Back_Page = "ZGSET";
        Back_Title = AL["Zul'Gurub Sets"];
    };
    ["ZGWarrior"] = {
        Title = AL["Warrior"];
        Back_Page = "ZGSET";
        Back_Title = AL["Zul'Gurub Sets"];
    };
    ["DEADMINES"] = {
        Title = AL["Defias Leather"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["WAILING"] = {
        Title = AL["Embrace of the Viper"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["SCARLET"] = {
        Title = AL["Chain of the Scarlet Crusade"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["BLACKROCKD"] = {
        Title = AL["The Gladiator"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["IRONWEAVE"] = {
        Title = AL["Ironweave Battlesuit"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["ScholoCloth"] = {
        Title = AL["Scholomance"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["ScholoLeather"] = {
        Title = AL["Scholomance"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["ScholoMail"] = {
        Title = AL["Scholomance"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["ScholoPlate"] = {
        Title = AL["Scholomance"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["STRAT"] = {
        Title = AL["The Postmaster"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["ScourgeInvasion"] = {
        Title = AL["Scourge Invasion"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["ShardOfGods"] = {
        Title = AL["Shard of the Gods"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["ZGRings"] = {
        Title = AL["Zul'Gurub"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["HakkariBlades"] = {
        Title = AL["Zul'Gurub"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["PrimalBlessing"] = {
        Title = AL["Zul'Gurub"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["SpiritofEskhandar"] = {
        Title = AL["Spirit of Eskhandar"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["DalRend"] = {
        Title = AL["Dal'Rend's Arms"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["SpiderKiss"] = {
        Title = AL["Spider's Kiss"];
        Back_Page = "PRE60SET";
        Back_Title = AL["Pre 60 Sets"];
    };
    ["SteelPlate"] = {
        Title = AL["Steel Plate"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["ImperialPlate"] = {
        Title = AL["Imperial Plate"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["TheDarksoul"] = {
        Title = AL["The Darksoul"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["BloodsoulEmbrace"] = {
        Title = AL["Bloodsoul Embrace"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
	["AugerersAttire"] = {
        Title = AL["Augerer's Attire"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
	["ShadoweaveSet"] = {
        Title = AL["Shadoweave"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
	["DivinersGarments"] = {
        Title = AL["Diviner's Garments"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
	["PillagersGarb"] = {
        Title = AL["Pillager's Garb"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["BloodvineG"] = {
        Title = AL["Bloodvine Garb"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
	["GriftersArmor"] = {
        Title = AL["Grifter's Armor"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
	["PrimalistsTrappings"] = {
        Title = AL["Primalist's Trappings"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["VolcanicArmor"] = {
        Title = AL["Volcanic Armor"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["IronfeatherArmor"] = {
        Title = AL["Ironfeather Armor"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["StormshroudArmor"] = {
        Title = AL["Stormshroud Armor"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["DevilsaurArmor"] = {
        Title = AL["Devilsaur Armor"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["BloodTigerH"] = {
        Title = AL["Blood Tiger Harness"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["PrimalBatskin"] = {
        Title = AL["Primal Batskin"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["RedDragonM"] = {
        Title = AL["Red Dragon Mail"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["GreenDragonM"] = {
        Title = AL["Green Dragon Mail"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["BlueDragonM"] = {
        Title = AL["Blue Dragon Mail"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["BlackDragonM"] = {
        Title = AL["Black Dragon Mail"];
        Back_Page = "CRAFTSET";
        Back_Title = AL["Crafted Sets"];
    };
    ["CraftedWeapons1"] = {
        Title = AL["Crafted Epic Weapons"];
        Back_Page = "CRAFTINGMENU";
        Back_Title = AL["Collections"];
    };
    ["Tabards"] = {
        Title = AL["Tabards"];
        Back_Page = "SETMENU";
        Back_Title = AL["Collections"];
    };
    ["Legendaries"] = {
        Title = AL["Legendary Items"];
        Back_Page = "SETMENU";
        Back_Title = AL["Collections"];
    };
    ["Artifacts"] = {
        Title = AL["Artifact Items"];
        Back_Page = "SETMENU";
        Back_Title = AL["Collections"];
    };
    ["PvPMountsPvP"] = {
        Title = AL["PvP Mounts"];
        Back_Page = "PVPMENU";
        Back_Title = AL["PvP Rewards"];
    };
    ["UnobMounts"] = {
        Title = AL["Unobtainable Mounts"];
        Back_Page = "SETMENU";
        Back_Title = AL["Collections"];
    };
    ["OldMounts"] = {
        Title = AL["Old Mounts"];
        Back_Page = "SETMENU";
        Back_Title = AL["Collections"];
    };
    ["RareMounts"] = {
        Title = AL["Rare Mounts"];
        Back_Page = "SETMENU";
        Back_Title = AL["Collections"];
    };
    ["RarePets1"] = {
        Title = AL["Rare Pets"];
        Next_Page = "RarePets2";
        Next_Title = AL["Rare Pets"];
        Back_Page = "SETMENU";
        Back_Title = AL["Collections"];
    };
    ["RarePets2"] = {
        Title = AL["Rare Pets"];
        Prev_Page = "RarePets1";
        Prev_Title = AL["Rare Pets"];
        Back_Page = "SETMENU";
        Back_Title = AL["Collections"];
    };
    ["WorldEpics1"] = {
        Title = AtlasLoot_TableNames["WorldEpics1"][1];
        Next_Page = "WorldEpics2";
        Next_Title = AtlasLoot_TableNames["WorldEpics2"][1];
        Back_Page = "WORLDEPICS";
        Back_Title = AL["World Epics"];
    };
    ["WorldEpics2"] = {
        Title = AtlasLoot_TableNames["WorldEpics2"][1];
        Next_Page = "WorldEpics3";
        Next_Title = AtlasLoot_TableNames["WorldEpics3"][1];
        Prev_Page = "WorldEpics1";
        Prev_Title = AtlasLoot_TableNames["WorldEpics1"][1];
        Back_Page = "WORLDEPICS";
        Back_Title = AL["World Epics"];
    };
    ["WorldEpics3"] = {
        Title = AtlasLoot_TableNames["WorldEpics3"][1];
        Prev_Page = "WorldEpics2";
        Prev_Title = AtlasLoot_TableNames["WorldEpics2"][1];
        Back_Page = "WORLDEPICS";
        Back_Title = AL["World Epics"];
    };
    ["ZGTrash1"] = {
        Title = AtlasLoot_TableNames["ZGTrash1"][1];
        Next_Page = "ZGTrash2";
        Next_Title = AtlasLoot_TableNames["ZGTrash2"][1];
    };
    ["ZGTrash2"] = {
        Title = AtlasLoot_TableNames["ZGTrash2"][1];
        Prev_Page = "ZGTrash1";
        Prev_Title = AtlasLoot_TableNames["ZGTrash1"][1];
    };
    ["AQ40Trash1"] = {
        Title = AtlasLoot_TableNames["AQ40Trash1"][1];
        Next_Page = "AQ40Trash2";
        Next_Title = AtlasLoot_TableNames["AQ40Trash2"][1];
    };
    ["AQ40Trash2"] = {
        Title = AtlasLoot_TableNames["AQ40Trash2"][1];
        Prev_Page = "AQ40Trash1";
        Prev_Title = AtlasLoot_TableNames["AQ40Trash1"][1];
    };
    ["ChildrensWeek"] = {
        Title = AL["Children's Week"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["Winterviel1"] = {
        Title = AL["Feast of Winter Veil"];
        Next_Page = "Winterviel2";
        Next_Title = AtlasLoot_TableNames["Winterviel2"][1];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["Winterviel2"] = {
        Title = AtlasLoot_TableNames["Winterviel2"][1];
        Prev_Page = "Winterviel1";
        Prev_Title = AL["Feast of Winter Veil"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["Halloween1"] = {
        Title = AL["Hallow's End"];
        Next_Page = "Halloween2";
        Next_Title = AL["Hallow's End"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["Halloween2"] = {
        Title = AL["Hallow's End"];
        Prev_Page = "Halloween1";
        Prev_Title = AL["Hallow's End"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["HarvestFestival"] = {
        Title = AL["Harvest Festival"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["Valentineday"] = {
        Title = AL["Love is in the Air"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["LunarFestival1"] = {
        Title = AL["Lunar Festival"];
        Next_Page = "LunarFestival2";
        Next_Title = AL["Lunar Festival"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["LunarFestival2"] = {
        Title = AL["Lunar Festival"];
        Prev_Page = "LunarFestival1";
        Prev_Title = AL["Lunar Festival"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["MidsummerFestival"] = {
        Title = AL["Midsummer Fire Festival"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["Noblegarden"] = {
        Title = AL["Noblegarden"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["ElementalInvasion"] = {
        Title = AL["Elemental Invasion"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["GurubashiArena"] = {
        Title = AL["Gurubashi Arena Booty Run"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["ScourgeInvasionEvent1"] = {
        Title = AL["Scourge Invasion"];
        Next_Page = "ScourgeInvasionEvent2";
        Next_Title = AtlasLoot_TableNames["ScourgeInvasionEvent2"][1];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["ScourgeInvasionEvent2"] = {
        Title = AtlasLoot_TableNames["ScourgeInvasionEvent2"][1];
        Prev_Page = "ScourgeInvasionEvent1";
        Prev_Title = AL["Scourge Invasion"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["FishingExtravaganza"] = {
        Title = AL["Stranglethorn Fishing Extravaganza"];
        Back_Page = "WORLDEVENTMENU";
        Back_Title = AL["World Events"];
    };
    ["AbyssalTemplars"] = {
        Title = AL["Abyssal Council"] .. " - " .. AL["Templars"];
        Back_Page = "AbyssalCouncil";
        Back_Title = AL["Abyssal Council"];
    };
    ["AbyssalDukes"] = {
        Title = AL["Abyssal Council"] .. " - " .. AL["Dukes"];
        Back_Page = "AbyssalCouncil";
        Back_Title = AL["Abyssal Council"];
    };
    ["AbyssalLords"] = {
        Title = AL["Abyssal Council"] .. " - " .. AL["High Council"];
        Back_Page = "AbyssalCouncil";
        Back_Title = AL["Abyssal Council"];
    };
    ["AlchemyApprentice1"] = {
        Title = AL["Alchemy"] .. ": " .. AL["Apprentice"];
        Back_Page = "ALCHEMYMENU";
        Back_Title = AL["Alchemy"];
        Next_Page = "AlchemyJourneyman1";
        Next_Title = AL["Alchemy"] .. ": " .. AL["Journeyman"];
    };
    ["AlchemyJourneyman1"] = {
        Title = AL["Alchemy"] .. ": " .. AL["Journeyman"];
        Back_Page = "ALCHEMYMENU";
        Back_Title = AL["Alchemy"];
        Next_Page = "AlchemyExpert1";
        Next_Title = AL["Alchemy"] .. ": " .. AL["Expert"];
        Prev_Page = "AlchemyApprentice1";
        Prev_Title = AL["Alchemy"] .. ": " .. AL["Apprentice"];
    };
    ["AlchemyExpert1"] = {
        Title = AL["Alchemy"] .. ": " .. AL["Expert"];
        Back_Page = "ALCHEMYMENU";
        Back_Title = AL["Alchemy"];
        Next_Page = "AlchemyArtisan1";
        Next_Title = AL["Alchemy"] .. ": " .. AL["Artisan"];
        Prev_Page = "AlchemyJourneyman1";
        Prev_Title = AL["Alchemy"] .. ": " .. AL["Journeyman"];
    };
    ["AlchemyArtisan1"] = {
        Title = AL["Alchemy"] .. ": " .. AL["Artisan"];
        Back_Page = "ALCHEMYMENU";
        Back_Title = AL["Alchemy"];
        Next_Page = "AlchemyArtisan2";
        Next_Title = AL["Alchemy"] .. ": " .. AL["Artisan"];
        Prev_Page = "AlchemyExpert1";
        Prev_Title = AL["Alchemy"] .. ": " .. AL["Expert"];
    };
    ["AlchemyArtisan2"] = {
        Title = AL["Alchemy"] .. ": " .. AL["Artisan"];
        Back_Page = "ALCHEMYMENU";
        Back_Title = AL["Alchemy"];
        Prev_Page = "AlchemyArtisan1";
        Prev_Title = AL["Alchemy"] .. ": " .. AL["Artisan"];
    };
    ["SmithingApprentice1"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Apprentice"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Next_Page = "SmithingJourneyman1";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Journeyman"];
    };
    ["SmithingJourneyman1"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Journeyman"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "SmithingApprentice1";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Apprentice"];
        Next_Page = "SmithingJourneyman2";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Journeyman"];
    };
    ["SmithingJourneyman2"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Journeyman"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "SmithingJourneyman1";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Journeyman"];
        Next_Page = "SmithingExpert1";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Expert"];
    };
    ["SmithingExpert1"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Expert"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "SmithingJourneyman2";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Journeyman"];
        Next_Page = "SmithingExpert2";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Expert"];
    };
    ["SmithingExpert2"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Expert"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "SmithingExpert1";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Expert"];
        Next_Page = "SmithingArtisan1";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Artisan"];
    };
    ["SmithingArtisan1"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Artisan"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "SmithingExpert2";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Expert"];
        Next_Page = "SmithingArtisan2";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Artisan"];
    };
    ["SmithingArtisan2"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Artisan"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "SmithingArtisan1";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Artisan"];
        Next_Page = "SmithingArtisan3";
        Next_Title = AL["Blacksmithing"];
    };
    ["SmithingArtisan3"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Artisan"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "SmithingArtisan2";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Artisan"];
        Next_Page = "Armorsmith1";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Armorsmith"];
    };
    ["Armorsmith1"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Armorsmith"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "SmithingArtisan3";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Artisan"];
        Next_Page = "Weaponsmith1";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Weaponsmith"];
    };
    ["Weaponsmith1"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Weaponsmith"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "Armorsmith1";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Armorsmith"];
        Next_Page = "Axesmith1";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Master Axesmith"];
    };
    ["Axesmith1"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Master Axesmith"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "Weaponsmith1";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Weaponsmith"];
        Next_Page = "Hammersmith1";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Master Hammersmith"];
    };
    ["Hammersmith1"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Master Hammersmith"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "Axesmith1";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Master Axesmith"];
        Next_Page = "Swordsmith1";
        Next_Title = AL["Blacksmithing"] .. ": " .. AL["Master Swordsmith"];
    };
    ["Swordsmith1"] = {
        Title = AL["Blacksmithing"] .. ": " .. AL["Master Swordsmith"];
        Back_Page = "SMITHINGMENU";
        Back_Title = AL["Blacksmithing"];
        Prev_Page = "Hammersmith1";
        Prev_Title = AL["Blacksmithing"] .. ": " .. AL["Master Hammersmith"];
    };
    ["EnchantingApprentice1"] = {
        Title = AL["Enchanting"] .. ": " .. AL["Apprentice"];
        Back_Page = "ENCHANTINGMENU";
        Back_Title = AL["Enchanting"];
        Next_Page = "EnchantingJourneyman1";
        Next_Title = AL["Enchanting"] .. ": " .. AL["Journeyman"];
    };
    ["EnchantingJourneyman1"] = {
        Title = AL["Enchanting"] .. ": " .. AL["Journeyman"];
        Back_Page = "ENCHANTINGMENU";
        Back_Title = AL["Enchanting"];
        Prev_Page = "EnchantingApprentice1";
        Prev_Title = AL["Enchanting"] .. ": " .. AL["Apprentice"];
        Next_Page = "EnchantingJourneyman2";
        Next_Title = AL["Enchanting"] .. ": " .. AL["Journeyman"];
    };
    ["EnchantingJourneyman2"] = {
        Title = AL["Enchanting"] .. ": " .. AL["Journeyman"];
        Back_Page = "ENCHANTINGMENU";
        Back_Title = AL["Enchanting"];
        Prev_Page = "EnchantingJourneyman1";
        Prev_Title = AL["Enchanting"] .. ": " .. AL["Journeyman"];
        Next_Page = "EnchantingExpert1";
        Next_Title = AL["Enchanting"] .. ": " .. AL["Expert"];
    };
    ["EnchantingExpert1"] = {
        Title = AL["Enchanting"] .. ": " .. AL["Expert"];
        Back_Page = "ENCHANTINGMENU";
        Back_Title = AL["Enchanting"];
        Prev_Page = "EnchantingJourneyman2";
        Prev_Title = AL["Enchanting"] .. ": " .. AL["Journeyman"];
        Next_Page = "EnchantingExpert2";
        Next_Title = AL["Enchanting"] .. ": " .. AL["Expert"];
    };
    ["EnchantingExpert2"] = {
        Title = AL["Enchanting"] .. ": " .. AL["Expert"];
        Back_Page = "ENCHANTINGMENU";
        Back_Title = AL["Enchanting"];
        Prev_Page = "EnchantingExpert1";
        Prev_Title = AL["Enchanting"] .. ": " .. AL["Expert"];
        Next_Page = "EnchantingArtisan1";
        Next_Title = AL["Enchanting"] .. ": " .. AL["Artisan"];
    };
    ["EnchantingArtisan1"] = {
        Title = AL["Enchanting"] .. ": " .. AL["Artisan"];
        Back_Page = "ENCHANTINGMENU";
        Back_Title = AL["Enchanting"];
        Prev_Page = "EnchantingExpert2";
        Prev_Title = AL["Enchanting"] .. ": " .. AL["Expert"];
        Next_Page = "EnchantingArtisan2";
        Next_Title = AL["Enchanting"] .. ": " .. AL["Artisan"];
    };
    ["EnchantingArtisan2"] = {
        Title = AL["Enchanting"] .. ": " .. AL["Artisan"];
        Back_Page = "ENCHANTINGMENU";
        Back_Title = AL["Enchanting"];
        Prev_Page = "EnchantingArtisan1";
        Prev_Title = AL["Enchanting"] .. ": " .. AL["Artisan"];
        Next_Page = "EnchantingArtisan3";
        Next_Title = AL["Enchanting"] .. ": " .. AL["Artisan"];
    };
    ["EnchantingArtisan3"] = {
        Title = AL["Enchanting"] .. ": " .. AL["Artisan"];
        Back_Page = "ENCHANTINGMENU";
        Back_Title = AL["Enchanting"];
        Prev_Page = "EnchantingArtisan2";
        Prev_Title = AL["Enchanting"] .. ": " .. AL["Artisan"];
    };
    ["EngineeringApprentice1"] = {
        Title = AL["Engineering"] .. ": " .. AL["Apprentice"];
        Back_Page = "ENGINEERINGMENU";
        Back_Title = AL["Engineering"];
        Next_Page = "EngineeringJourneyman1";
        Next_Title = AL["Engineering"] .. ": " .. AL["Journeyman"];
    };
    ["EngineeringJourneyman1"] = {
        Title = AL["Engineering"] .. ": " .. AL["Journeyman"];
        Back_Page = "ENGINEERINGMENU";
        Back_Title = AL["Engineering"];
        Prev_Page = "EngineeringApprentice1";
        Prev_Title = AL["Engineering"] .. ": " .. AL["Apprentice"];
        Next_Page = "EngineeringJourneyman2";
        Next_Title = AL["Engineering"] .. ": " .. AL["Journeyman"];
    };
    ["EngineeringJourneyman2"] = {
        Title = AL["Engineering"] .. ": " .. AL["Journeyman"];
        Back_Page = "ENGINEERINGMENU";
        Back_Title = AL["Engineering"];
        Prev_Page = "EngineeringJourneyman1";
        Prev_Title = AL["Engineering"] .. ": " .. AL["Journeyman"];
        Next_Page = "EngineeringExpert1";
        Next_Title = AL["Engineering"] .. ": " .. AL["Expert"];
    };
    ["EngineeringExpert1"] = {
        Title = AL["Engineering"] .. ": " .. AL["Expert"];
        Back_Page = "ENGINEERINGMENU";
        Back_Title = AL["Engineering"];
        Prev_Page = "EngineeringJourneyman2";
        Prev_Title = AL["Engineering"] .. ": " .. AL["Journeyman"];
        Next_Page = "EngineeringExpert2";
        Next_Title = AL["Engineering"] .. ": " .. AL["Expert"];
    };
    ["EngineeringExpert2"] = {
        Title = AL["Engineering"] .. ": " .. AL["Expert"];
        Back_Page = "ENGINEERINGMENU";
        Back_Title = AL["Engineering"];
        Prev_Page = "EngineeringExpert1";
        Prev_Title = AL["Engineering"] .. ": " .. AL["Expert"];
        Next_Page = "EngineeringArtisan1";
        Next_Title = AL["Engineering"] .. ": " .. AL["Artisan"];
    };
    ["EngineeringArtisan1"] = {
        Title = AL["Engineering"] .. ": " .. AL["Artisan"];
        Back_Page = "ENGINEERINGMENU";
        Back_Title = AL["Engineering"];
        Prev_Page = "EngineeringExpert2";
        Prev_Title = AL["Engineering"] .. ": " .. AL["Expert"];
        Next_Page = "EngineeringArtisan2";
        Next_Title = AL["Engineering"] .. ": " .. AL["Artisan"];
    };
    ["EngineeringArtisan2"] = {
        Title = AL["Engineering"] .. ": " .. AL["Artisan"];
        Back_Page = "ENGINEERINGMENU";
        Back_Title = AL["Engineering"];
        Prev_Page = "EngineeringArtisan1";
        Prev_Title = AL["Engineering"] .. ": " .. AL["Artisan"];
        Next_Page = "Gnomish1";
        Next_Title = AL["Engineering"] .. ": " .. AL["Gnomish Engineering"];
    };
    ["Gnomish1"] = {
        Title = AL["Engineering"] .. ": " .. AL["Gnomish Engineering"];
        Back_Page = "ENGINEERINGMENU";
        Back_Title = AL["Engineering"];
        Prev_Page = "EngineeringArtisan2";
        Prev_Title = AL["Engineering"] .. ": " .. AL["Artisan"];
        Next_Page = "Goblin1";
        Next_Title = AL["Engineering"] .. ": " .. AL["Goblin Engineering"];
    };
    ["Goblin1"] = {
        Title = AL["Engineering"] .. ": " .. AL["Goblin Engineering"];
        Back_Page = "ENGINEERINGMENU";
        Back_Title = AL["Engineering"];
        Prev_Page = "Gnomish1";
        Prev_Title = AL["Engineering"] .. ": " .. AL["Gnomish Engineering"];
    };
    ["LeatherApprentice1"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Apprentice"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Next_Page = "LeatherJourneyman1";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Journeyman"];
    };
    ["LeatherJourneyman1"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Journeyman"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "LeatherApprentice1";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Apprentice"];
        Next_Page = "LeatherJourneyman2";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Journeyman"];
    };
    ["LeatherJourneyman2"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Journeyman"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "LeatherJourneyman1";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Journeyman"];
        Next_Page = "LeatherExpert1";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Expert"];
    };
    ["LeatherExpert1"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Expert"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "LeatherJourneyman2";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Journeyman"];
        Next_Page = "LeatherExpert2";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Expert"];
    };
    ["LeatherExpert2"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Expert"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "LeatherExpert1";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Expert"];
        Next_Page = "LeatherArtisan1";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Artisan"];
    };
    ["LeatherArtisan1"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Artisan"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "LeatherExpert2";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Expert"];
        Next_Page = "LeatherArtisan2";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Artisan"];
    };
    ["LeatherArtisan2"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Artisan"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "LeatherArtisan1";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Artisan"];
        Next_Page = "LeatherArtisan3";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Artisan"];
    };
    ["LeatherArtisan3"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Artisan"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "LeatherArtisan2";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Artisan"];
        Next_Page = "Dragonscale1";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Dragonscale Leatherworking"];
    };
    ["Dragonscale1"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Dragonscale Leatherworking"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "LeatherArtisan3";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Artisan"];
        Next_Page = "Elemental1";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Elemental Leatherworking"];
    };
    ["Elemental1"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Elemental Leatherworking"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "Dragonscale1";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Dragonscale Leatherworking"];
        Next_Page = "Tribal1";
        Next_Title = AL["Leatherworking"] .. ": " .. AL["Tribal Leatherworking"];
    };
    ["Tribal1"] = {
        Title = AL["Leatherworking"] .. ": " .. AL["Tribal Leatherworking"];
        Back_Page = "LEATHERWORKINGMENU";
        Back_Title = AL["Leatherworking"];
        Prev_Page = "Elemental1";
        Prev_Title = AL["Leatherworking"] .. ": " .. AL["Elemental Leatherworking"];
    };
    ["Herbalism1"] = {
        Title = AL["Herbalism"];
        Back_Page = "CRAFTINGMENU";
        Back_Title = AL["Crafting"];
        Next_Page = "Herbalism2";
        Next_Title = AL["Herbalism"];
    };
    ["Herbalism2"] = {
        Title = AL["Herbalism"];
        Back_Page = "CRAFTINGMENU";
        Back_Title = AL["Crafting"];
        Prev_Page = "Herbalism1";
        Prev_Title = AL["Herbalism"];
    };
    ["Mining1"] = {
        Title = AL["Mining"];
        Back_Page = "MININGMENU";
        Back_Title = AL["Crafting"];
        Next_Page = "Mining2";
        Next_Title = AL["Mining"];
    };
    ["Mining2"] = {
        Title = AL["Mining"];
        Back_Page = "MININGMENU";
        Back_Title = AL["Crafting"];
        Next_Page = "Smelting1";
        Next_Title = AL["Smelting"];
        Prev_Page = "Mining1";
        Prev_Title = AL["Mining"];
    };
    ["Smelting1"] = {
        Title = AL["Smelting"];
        Back_Page = "MININGMENU";
        Back_Title = AL["Crafting"];
        Prev_Page = "Mining2";
        Prev_Title = AL["Mining"];
    };
    ["TailoringApprentice1"] = {
        Title = AL["Tailoring"] .. ": " .. AL["Apprentice"];
        Back_Page = "TAILORINGMENU";
        Back_Title = AL["Tailoring"];
        Next_Page = "TailoringJourneyman1";
        Next_Title = AL["Tailoring"] .. ": " .. AL["Journeyman"];
    };
    ["TailoringJourneyman1"] = {
        Title = AL["Tailoring"] .. ": " .. AL["Journeyman"];
        Back_Page = "TAILORINGMENU";
        Back_Title = AL["Tailoring"];
        Prev_Page = "TailoringApprentice1";
        Prev_Title = AL["Tailoring"] .. ": " .. AL["Apprentice"];
        Next_Page = "TailoringJourneyman2";
        Next_Title = AL["Tailoring"] .. ": " .. AL["Journeyman"];
    };
    ["TailoringJourneyman2"] = {
        Title = AL["Tailoring"] .. ": " .. AL["Journeyman"];
        Back_Page = "TAILORINGMENU";
        Back_Title = AL["Tailoring"];
        Prev_Page = "TailoringJourneyman1";
        Prev_Title = AL["Tailoring"] .. ": " .. AL["Journeyman"];
        Next_Page = "TailoringExpert1";
        Next_Title = AL["Tailoring"] .. ": " .. AL["Expert"];
    };
    ["TailoringExpert1"] = {
        Title = AL["Tailoring"] .. ": " .. AL["Expert"];
        Back_Page = "TAILORINGMENU";
        Back_Title = AL["Tailoring"];
        Prev_Page = "TailoringJourneyman2";
        Prev_Title = AL["Tailoring"] .. ": " .. AL["Journeyman"];
        Next_Page = "TailoringExpert2";
        Next_Title = AL["Tailoring"] .. ": " .. AL["Expert"];
    };
    ["TailoringExpert2"] = {
        Title = AL["Tailoring"] .. ": " .. AL["Expert"];
        Back_Page = "TAILORINGMENU";
        Back_Title = AL["Tailoring"];
        Prev_Page = "TailoringExpert1";
        Prev_Title = AL["Tailoring"] .. ": " .. AL["Expert"];
        Next_Page = "TailoringArtisan1";
        Next_Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
    };
    ["TailoringArtisan1"] = {
        Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
        Back_Page = "TAILORINGMENU";
        Back_Title = AL["Tailoring"];
        Prev_Page = "TailoringExpert2";
        Prev_Title = AL["Tailoring"] .. ": " .. AL["Expert"];
        Next_Page = "TailoringArtisan2";
        Next_Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
    };
    ["TailoringArtisan2"] = {
        Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
        Back_Page = "TAILORINGMENU";
        Back_Title = AL["Tailoring"];
        Prev_Page = "TailoringArtisan1";
        Prev_Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
        Next_Page = "TailoringArtisan3";
        Next_Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
    };
    ["TailoringArtisan3"] = {
        Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
        Back_Page = "TAILORINGMENU";
        Back_Title = AL["Tailoring"];
        Prev_Page = "TailoringArtisan2";
        Prev_Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
        Next_Page = "TailoringArtisan4";
        Next_Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
    };
    ["TailoringArtisan4"] = {
        Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
        Back_Page = "TAILORINGMENU";
        Back_Title = AL["Tailoring"];
        Prev_Page = "TailoringArtisan3";
        Prev_Title = AL["Tailoring"] .. ": " .. AL["Artisan"];
    };
    ["CookingApprentice1"] = {
        Title = AL["Cooking"] .. ": " .. AL["Apprentice"];
        Back_Page = "COOKINGMENU";
        Back_Title = AL["Cooking"];
        Next_Page = "CookingJourneyman1";
        Next_Title = AL["Cooking"] .. ": " .. AL["Journeyman"];
    };
    ["CookingJourneyman1"] = {
        Title = AL["Cooking"] .. ": " .. AL["Journeyman"];
        Back_Page = "COOKINGMENU";
        Back_Title = AL["Cooking"];
        Prev_Page = "CookingApprentice1";
        Prev_Title = AL["Cooking"] .. ": " .. AL["Apprentice"];
        Next_Page = "CookingExpert1";
        Next_Title = AL["Cooking"] .. ": " .. AL["Journeyman"];
    };
    ["CookingExpert1"] = {
        Title = AL["Cooking"] .. ": " .. AL["Expert"];
        Back_Page = "COOKINGMENU";
        Back_Title = AL["Cooking"];
        Prev_Page = "CookingJourneyman1";
        Prev_Title = AL["Cooking"] .. ": " .. AL["Journeyman"];
        Next_Page = "CookingArtisan1";
        Next_Title = AL["Cooking"] .. ": " .. AL["Artisan"];
    };
    ["CookingArtisan1"] = {
        Title = AL["Cooking"] .. ": " .. AL["Artisan"];
        Back_Page = "COOKINGMENU";
        Back_Title = AL["Cooking"];
        Prev_Page = "CookingExpert1";
        Prev_Title = AL["Cooking"] .. ": " .. AL["Expert"];
    };
    ["FirstAid1"] = {
        Title = AL["First Aid"];
        Back_Page = "CRAFTINGMENU";
        Back_Title = AL["Crafting"];
    };
    ["Survival1"] = {
        Title = AL["Survival"];
        Back_Page = "CRAFTINGMENU";
        Back_Title = AL["Crafting"];
    };
    ["Poisons1"] = {
        Title = AL["Poisons"];
        Back_Page = "CRAFTINGMENU";
        Back_Title = AL["Crafting"];
    };
};
