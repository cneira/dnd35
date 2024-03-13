//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::::::::::::::::::::::: Shayan's Subrace Engine :::::::::::::::::::::::::::::
//::::::::::::::::::::::: File Name: sha_subr_methds :::::::::::::::::::::::::::
//:::::::::::::::::::::::::: Include script ::::::::::::::::::::::::::::::::::::
//:: Written by: Shayan                                                     :://
//:: Contact: mail_shayan@yhaoo.com                                         :://
//
// ::Description: Holds all the methods used in the Subrace System. DO NOT CHANGE
// ::             ANYTHING UNLESS YOU ARE CERTAIN.
// ::             This is the 'core engine script'. In updates, more than likely
// ::             this script is changed... so unless you do not plan to update to
// ::             possible future releases of this engine, it will be in your best
// ::             interest NOT to make any changes to this script. Because then you
// ::             will have to redo them again.
// ::             Should you disregard this warning and proceed to editing...
// ::             Remember that:
// ::             * If you have made a change you must recompile all scripts for
// ::               changes to take place.
//
// ::Please refer to the script file 'sha_subr_consts' to change any values of the
// ::constants or default values.






// ::Version 1.4: Reduced the numbers of local variables, by "encoding a single interger
// ::             variable to hold several 'bits' of information". - Using Axe Murderer's Flag-sets.

// ::Version 1.2: Support for NWNX added.

//Uncomment the line below if you wish to use NWNXbase instead.
//(Make sure you have imported in these files from the NWNX package, available from
// ::  http://www.nwnx.org)
// :: You must also uncomment line 887. Then recompile all scripts!

//#include "aps_include"

#include "sha_subr_consts"
#include "sha_misc_funcs"

// :: Version 2.5: LETO Include functions.
#include "sha_leto_inc"

//Version 1.1: Changed from storing the data on the module to an object.
//object oStorer = GetObjectByTag(SUBRACE_INFO_STORER_TAG);
//Version 1.1a Revision: Changed it back to Module for faster access.
object oStorer = GetModule();








/*
::::::::::::::::::::::::::: Function definers ::::::::::::::::::::::::::::::::::
*/
// :: Below lies the list of all the functions useable OnModuleLoad to setup
// :: a subrace.



//:: - ALL SUBRACE RELATED METHODS MUST BE CALLED AFTER THIS METHOD! -
//:: -- The Main function. Call this OnModuleLoad.
//
// ::Race:   This is the base race that you want to create your subrace from
// ::        Use ONLY: RACIAL_TYPE_ALL, or RACIAL_TYPE_DWARF, RACIAL_TYPE_ELF,
// ::                  RACIAL_TYPE_GNOME, RACIAL_TYPE_HALFELF, RACIAL_TYPE_HALFLING,
// ::                  RACIAL_TYPE_HALFORC, or RACIAL_TYPE_HUMAN.
// ::       If you want to add additional races that can become part of this subrace call
// ::       AddAdditionalBaseRaceToSubrace() AFTER this method.
//
// ::SubraceName:   The subrace's name. This is what the PC will have to type in his/her
// ::               Subrace field. DO NOT HAVE SPACES IN NAMES.
// ::               IE: Use "Dark-elf" NOT "Dark elf".
// ::               (Not case sensitive.)
//
// ::HideResRef:    This is the resref of the Creature Hide/Skin you want to equip on the PC.
// ::               This will have all the subrace traits like ability modifiers and base feats etc.
//
// ::                If you do not want a skin, write either "none" or leave it as blank.
//
// ::UniqueItemResref:   This is the resref of the item that you want given to the player. For example this item
// ::                    could hold can spells on it, or just description of the subrace. Ideally this item will not be droppable,
// ::                    and is marked as being a plot item. Regardless of what type of item this is it will be given to player when they enter the module.
// ::                    (If they lose it or drop it they will again get it back on the next time they enter).
//
// ::                    If you do not want to give the PC a unique item then, write either "none" or leave it as blank.
//
// ::IsLightSensitive:   Set to TRUE if the subrace is light senstive. IE: Blinded when in Sunlight and/or gets saves and AB decreases.
// ::                    If the PC does not pass the fort saving throw, then it is blinded for that round.
// ::                    The DC for the saving throw can be changed by changing the value of
// ::                    LIGHT_SENSITIVE_SAVING_THROW_DC in the file sha_subr_consts. Also you can change the interval (rounds) between each time the PC
// ::                    is 'struk' by light by changing the value of LIGHT_BLINDNESS_STRIKES_EVERY_ROUND.  And also you can change the number of rounds
// ::                    the PC stays blinded for if it fails the saving throw by changing tha value of LIGHT_STRUCK_BLIND_FOR_ROUNDS.
//
// ::                    If APPLY_AB_AND_SAVING_THROW_DECREASES_IN_LIGHT is set to TRUE, then the PC also suffers
// ::                    an attack bonus decrease of LIGHT_AB_DECREASE and saving throw decrease of LIGHT_SAVE_DECREASE for a number of rounds
// ::                    determined by: LIGHT_CAUSES_AB_AND_SAVES_DECREASE_FOR_ROUNDS.
//
// ::                    Rememeber: IF YOU CHANGE ANYTHING IN THE CONSTANTS FILE, IT WILL APPLY TO ALL SUBRACES.
// ::                               (IE: If you change the DC for the saving throw then all subraces that have light sensitivity will have to make that saving throw).
//
// ::DamageTakenWhileInLight:  The amount of divine Damage the PC suffers ever round while
// ::                          it is in sunlight. Note: PC does not necessarily have to be Light Sensitive
// ::                          for this to work.
// ::                          If this value is negative then the PC will regenerate that amount.
//
// ::IsUndergroundSensitive:   Same as IsLightSenstive but this applies when the PC is in
// ::                          Underground type of areas. This does not mean the PC is affected by Night time.
//
// ::DamageTakenWhileInUnderground:  The amount of Negative Damage taken per round while in the Underground.
// ::                                 Note: This too doesn't need the PC to be Under ground sensitive to apply.
// ::                                 If this value is negative then the PC will regenerate that amount.
//
// :: ECL:          Effective Character Level: Use any integer value.
// ::                 (For those that do not know what this is...
// ::                   Effective Character Level is a way of lessening your subrace's bonus abilities
// ::                   by reducing the amount of experience points gained per kill.)
// ::                   IE: If you have a Subrace with ECL of 3, then a PC (Player character) of level 10 belonging to
// ::                       that subrace is regarded being level 13 when gaining XP points per kill.
// ::                       Thus will get less experience points.
// ::                       NOTE: This can work for negative values as well.
//
// :: IsUndead:             Mark the PC belonging to this sub-race as being Undead. It will mean that Healing spells will hurt the PC.
// ::                       And harming spells will heal the PC.
//
// :: PrestigiousSubrace:   Mark this sub-race as being prestigious. Which means players can't become part of it when they enter in with a level 1 character with this as their chosen subrace.
// ::                      (Set this to TRUE, if you are making a subrace that players can become part of once they reach a certain level in another sub-race)
// ::                       -Refer to SetupSubraceSwitch() for more information -
//
// :: Example:  You wish to create a subrace called Drow, and you have created a Creature Skin/Hide in the toolset with
// ::          resref "sha_pc_drow". The Unique item (which contains spell like abilities and information about the Drow subrace)
// ::          has the resref "sha_subrace_drow". And you want to make the Drow light sensitive and take 2 divine damage while in light areas.
// ::          Also you would like to mark the Drow as having an Effective Character level of +1.
// ::          Simply call this OnModuleLoad. (Remember to #include "sha_subr_methds", in the script)
//
// ::          CreateSubrace(RACIAL_TYPE_ELF, "drow", "sha_pc_drow", "sha_subrace_drow", TRUE, 2, FALSE, 0, 1);
void CreateSubrace(int Race, string SubraceName, string HideResRef = "", string UniqueItemResref = "", int IsLightSensitive = FALSE, int DamageTakenWhileInLight = 0, int IsUndergroundSensitive = FALSE, int DamageTakenWhileInUnderground = 0, int ECL = 0, int IsUndead = FALSE, int PrestigiousSubrace = FALSE);


//- Add another Race that can be part of the subrace.
// :: subraceName should be the same as the Subrace's name used in  CreateSubrace()
// :: AdditionalBaseRace can only be RACIAL_TYPE_ALL, RACIAL_TYPE_DWARF, RACIAL_TYPE_ELF, RACIAL_TYPE_GNOME,
// ::                                  RACIAL_TYPE_HALFELF, RACIAL_TYPE_HALFLING, RACIAL_TYPE_HALFORC, or RACIAL_TYPE_HUMAN.
void AddAdditionalBaseRaceToSubrace(string subraceName, int AdditionalBaseRace);


// ::Limit the classes the PC can be, when trying to be part of this subrace.
// ::      subraceName should be the same as the Subrace's name used in  CreateSubrace()
// ::      Set the CanBe_<Class> values as desired.
//
// ::Note: This will only check PC's first class. IE: You limit your subrace's classes to only Fighter and Rogue
// ::      A player with classes Wizard/Fighter/Cleric will not meet the criteria, nor will a Monk/Cleric/Rogue.
// ::      Only a PC with either Rogue or Fighter as their first class will meet the requirement.
// ::      IE: Rogue/WeaponMaster or Fighter/Wizard/Cleric.
void CreateSubraceClassRestriction(string subraceName, int CanBe_Barbarian = TRUE, int CanBe_Bard = TRUE, int CanBe_Cleric = TRUE, int CanBe_Druid = TRUE, int CanBe_Fighter = TRUE, int CanBe_Monk = TRUE, int CanBe_Paladin = TRUE, int CanBe_Ranger = TRUE, int CanBe_Rogue = TRUE, int CanBe_Sorcerer = TRUE, int CanBe_Wizard = TRUE);


//Limit the Alignment the PC can be, when trying to be part of this subrace.
//Note this alignment restriction only applies when the PC enters the module for the first time. (A database entry is made).
// ::   IE: It will not stop the PC from being part of the subrace after the PC adventures and changes in alignment.
//
// ::   subraceName should be the same as the Subrace's name used in  CreateSubrace()
// ::   Set the CanBe_<Alignment> to as desired.
void CreateSubraceAlignmentRestriction(string subraceName, int CanBeAlignment_Good = TRUE , int CanBeAlignment_Neutral1 = TRUE, int CanBeAlignment_Evil = TRUE, int CanBeAlignment_Lawful = TRUE, int CanBeAlignment_Neutral2 = TRUE, int CanBeAlignment_Chaotic = TRUE);


//Use this method of Spell resistance if you want the Spell resistance to increase (or decrease) with the PC's level.
// ::   subraceName should be the same as the Subrace's name used in  CreateSubrace()
//
// ::   SpellResistanceBase: Is the vaule of SR the PC gains at level 1
// ::   int SpellResistanceMax: Is the value of the SR PC gains at the maximum level achievable (default is 40, you can change the maximum level value in "sha_subr_consts")
void CreateSubraceSpellResistance(string subraceName, int SpellResistanceBase, int SpellResistanceMax);


//Use this method if you want the PC's Appearance to change for the subrace.
//
// :: subraceName should be the same as the Subrace's name used in  CreateSubrace()
// :: AppearanceChangeTime: Time of day you want the Appearance to change.
// ::                         if you want to have a permanent appearance change then use: TIME_BOTH.
// ::                         if you want the appearance to only change when it is night time and revert back when it is day time then use: TIME_DAY.
// ::                         if you want the appearance to only change when it is day time and revert back to the PC's original form when it is night time then use: TIME_NIGHT.
// ::                         if you plan on making a controlable appearance, then set to TIME_NONE. (Refer to .pdf tutorial for more information)
//
// ::MaleAppearance: This is the appearance of a Male PC. Use any of the APPEARANCE_TYPE_* values.
// ::FemaleAppearance: This is the appearance of a Female PC. Use any of the APPEARANCE_TYPE_* values.
// ::Level: From which level to apply this appearance change from...
//
// ::NOTE: Not all APPEARANCE_TYPE_* constants work in standard NWN. IE: If you use APPEARANCE_TYPE_WYRMLING_BLACK, and you only have installed just NWN (no expansions),
// ::      Then your appearance will be different... (in the case of wyrmiling, you will look like a mephit) - You have been warned.
void CreateSubraceAppearance(string subraceName, int AppearanceChangeTime, int MaleAppearance, int FemaleAppearance, int Level = 1);

// - (You may use this twice per subrace. Once for TIME_DAY, and once for TIME_NIGHT) -
//
// Use this method if you want the PC's ability scores or AC or AB to change when it is either day or night.
// (The use of this function is slightly more complicated)
//
// ::   subraceName: Should be the same as the Subrace's name used in CreateSubrace()
//
// ::   struct SubraceStats Stats:  (Explained below)
//
// ::   TimeToApply: if you want the stats/ability scores to only change when it is night time and revert back when it is day time then use: TIME_NIGHT.
// ::                if you want the stats/ability scores to only change when it is day time and revert back to the PC's original stats/ability scores when it is night time then use: TIME_DAY.
//
// ::   InInteriorArea:   Set to TRUE if you want these changes to ability scores to happen in Interior Areas.
// ::   InExteriorArea:   Set to TRUE if you want these changes to ability scores to happen in Exterior Areas.
// ::   InNaturalArea:    Set to TRUE if you want these changes to ability scores to happen in Natural Areas.
// ::   InArtifacialArea: Set to TRUE if you want these changes to ability scores to happen in Artifical Areas.
// ::   InUndergroundArea: Set to TRUE if you want these changes to ability scores to happen in Underground Areas.
// ::   InAbovegroundArea:  Set to TRUE if you want these changes to ability scores to happen in Above Ground Areas.
//
// :: How to use this function.
//
// :: First create a structure of SubraceStats. It can be done by:
//
// :: struct SubraceStats  mystats = CreateCustomeStats(<fill in appropriate values. Look at CreateCustomeStats method for more details>).
//
// :: then you want to add this to your subrace. So call
//
// :: CreateTemporaryStatModifier("mysubrace", mystats, TIME_DAY, TRUE, FALSE);
//
// ::Hence the PC belonging to "mysubrace" will have it's ability scores changed during day time, when they are in Exterior (IE: outdoors) areas.
void CreateTemporaryStatModifier(string subraceName, struct SubraceStats Stats, int TimeToApply, int InInteriorArea = TRUE, int InExteriorArea = TRUE, int InNaturalArea = TRUE, int InArtifacialArea = TRUE, int InUndergroundArea = TRUE, int InAbovegroundArea = TRUE);


//This is the first half of CreateTemporaryStatModifier function.
//
//(The use of this function is slightly more complicated)
//
// ::       StatModiferType: Use only SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE (if you wish to increase or decrease a PC's ability scores/AC/AB based on the percentage of the PC's current ability scores)
// ::                         or SUBRACE_STAT_MODIFIER_TYPE_POINTS (if you wish to increase or decrease a PC's ability scores/AC/AB by constant number.
// ::       Fill in the values of the floats appropriately.
//
// ::Example: You wish to change reduce the PC's strength by 80% and increase it's dexterity by 50% and increase it's consitituion by 60%, whilst you want to increase the AC by 65%, but reduce the AB by 10%.
//
// ::so you create your stats:
//
// ::struct SubraceStats mystats = CreateCustomStats(SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE, -0.80, 0.50, 0.60, 0.0, 0.0, 0.0, 0.65, -0.10);
//
// ::You then use this in CreateTemporaryStatModifier().
struct SubraceStats CreateCustomStats(int StatModifierType, float StrengthModifier, float DexterityModifier, float ConstitutionModifier, float IntelligenceModifier, float WisdomModifier, float CharismaModifier, float ACModifier, float ABModifier);



//(Use this only ONCE per subrace. It will not work correctly if used more than once per subrace)
//
//This method will allow you to disable/enable the use of Melee or ranged weapons or other types of weapons by the particular subrace.
//
// ::   subraceName: Should be the same as the Subrace's name used in CreateSubrace()
// ::   WeaponType: The type of weapon you want the restriction to apply to...
// ::                Use either SUBRACE_RESTRICTION_WEAPON_MELEE (gloves are excluded)
// ::                            or SUBRACE_RESTRICTION_WEAPON_RANGED (ranged and throwing type of weapons)
// ::                             or SUBRACE_RESTRICTION_WEAPON_EXOTIC or SUBRACE_RESTRICTION_WEAPON_LARGE or
// ::                               or SUBRACE_RESTRICTION_WEAPON_MARTIAL or SUBRACE_RESTRICTION_WEAPON_SIMPLE
// ::                                or SUBRACE_RESTRICTION_WEAPON_TINY or  SUBRACE_RESTRICTION_WEAPON_ALL
//
// ::  TimeOfDay: To Restrict the use of WeaponType at various times: Use TIME_NIGHT, TIME_DAY or TIME_BOTH
//
// ::  Allow: If you want to allow the use of ONLY these weapons, then set it to TRUE. If set to FALSE, the engine
// ::         will prohibit the use of WeaponType.
void SubraceRestrictUseOfWeaponsOfType(string subraceName, int WeaponType, int TimeOfDay = TIME_BOTH, int Allow = FALSE);



//(Use this only ONCE per subrace. It will not work correctly if used more than once per subrace)
//
// ::This method will allow you to disable/enable the use of items that grant defense. (Shields and Armour)
//
// ::   subraceName: Should be the same as the Subrace's name used in CreateSubrace()
// ::   Type: The category of armor and shield thats you want the restriction to apply to...
//
// ::         SUBRACE_RESTRICTION_DEFENSE_ALL (All shields and Armor -including cloths)
// ::         SUBRACE_RESTRICTION_DEFENSE_CLOTHING (Cloths only, no shields)
// ::         SUBRACE_RESTRICTION_DEFENSE_HEAVY (Full plates, half plates and Tower shields, and helms)
// ::         SUBRACE_RESTRICTION_DEFENSE_MEDIUM (Chain Shirt, Scale Mail, Chainmail, Breastplate, Splint Mail, Banded Mail and Large Shields and helms)
// ::         SUBRACE_RESTRICTION_DEFENSE_LIGHT (Padded, Leather armour,Studded Armor and small shields.)
//
// ::  TimeOfDay: To Restrict the use of WeaponType at various times: Use TIME_NIGHT, TIME_DAY or TIME_BOTH
//
// ::  Allow: If you want to allow the use of ONLY these weapons, then set it to TRUE. If set to FALSE, the engine
// ::         will prohibit the use of WeaponType.
void SubraceRestrictUseOfArmourAndShieldsOfType(string subraceName, int Type, int TimeOfDay = TIME_BOTH, int Allow = FALSE);


//:: Add a favored class to the subrace.
//
// (Use this only ONCE per subrace. It will not work correctly if used more than once per subrace)
// This would mean that when determining XP penalty for multiclassing, the favored
// classes do not apply when determining it (Works the same way as default NWN favored classes)
// ::(This will work ONLY if you are using the attached Shayan's XP System script).
//
//NOTE: You can use any playable base CLASS_TYPE_* constant. Do NOT USE Prestige classes,
// ::     as they are not taken into consideration when determining multiclassing penalty by NWN.
// ::     Also if you do specify a prestige class it will end up giving players a 20% boost to the XP gained.
// ::     (Thanks to Masterlexx for spotting this bug)
void AddSubraceFavoredClass(string subraceName, int MaleFavoredClass, int FamaleFavoredClass);

//Add a permanent or a temporary subrace effect on the PC, during day or night or permanently.
//
//:: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
//:: EffectID: There are a limited number of effects you can use here...
//::           EFFECT_TYPE_ARCANE_SPELL_FAILURE
//::           EFFECT_TYPE_BLINDNESS
//::           EFFECT_TYPE_CHARMED
//::           EFFECT_TYPE_CONCEALMENT
//::           EFFECT_TYPE_CONFUSED
//::           EFFECT_TYPE_CUTSCENEGHOST
//::           EFFECT_TYPE_HASTE
//::           EFFECT_TYPE_IMMUNITY
//::           EFFECT_TYPE_IMPROVEDINVISIBILITY
//::           EFFECT_TYPE_INVISIBILITY
//::           EFFECT_TYPE_MISS_CHANCE
//::           EFFECT_TYPE_MOVEMENT_SPEED_DECREASE
//::           EFFECT_TYPE_MOVEMENT_SPEED_INCREASE
//::           EFFECT_TYPE_POLYMORPH
//::           EFFECT_TYPE_REGENERATE
//::           EFFECT_TYPE_SANCTUARY
//::           EFFECT_TYPE_SLOW
//::           EFFECT_TYPE_TEMPORARY_HITPOINTS
//::           EFFECT_TYPE_TRUESEEING
//::           EFFECT_TYPE_ULTRAVISION
//::           EFFECT_TYPE_VISUALEFFECT
//
// ::  Value1: This is the value of the first parameter (from left) that you can input for the effect.
// ::          IE: If you choose EFFECT_TYPE_CONCEALMENT, which means the effect applied will be:
// ::          EffectConcealment(int nPercentage, int nMissType=MISS_CHANCE_TYPE_NORMAL)
// ::          Thus Value1 will be the value of nPercentage.
// ::          YOU MUST INPUT A VALUE! IF NOT THE SCRIPT WILL PUT IN 0!!
//
// :: Value2: This is the value of the second parameter you can input for the effect.
// ::         IE: (Refer to Value1's example) This will be the value of nMissType.
// ::         YOU MUST INPUT A VALUE! IF NOT THE SCRIPT WILL PUT IN 0!!
//
// ::nDurationType: Duration type of the effect being applied...
// ::                DURATION_TYPE_INSTANT, DURATION_TYPE_PERMANENT, or DURATION_TYPE_TEMPORARY.
//
// ::fDuration: The number of seconds the effect should last for...
// ::           (Put 0.0 if you are making it last "forever" -IE: Whole of day time, or night time or permanetly)
//
// ::TimeOfDay: The time of day you want this applied. Use TIME_BOTH if you want this permanently applied on the PC.
//
// Use as many times as desired.
void AddSubraceEffect(string subraceName, int EffectID, int Value1, int Value2, int nDurationType, float fDuration, int TimeOfDay);

//Add a different skin to the subrace at specified level. (Use as many times as desired)
//
//::    subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
//::    SkinResRef: The Blueprint ResRef of the skin that you want the subrace to be equipped.
//::    EquipLevel: The level at which you want the skin to be applied.
//::    iTime: The time at which you want the skin to be equipped. (Use TIME_DAY, TIME_NIGHT, or TIME_BOTH.)
//
// ::Example: You want to add a skin for the subrace Illithid to use at level 15, during day time.
//
// ::Then call onModuleLoad script:
// ::        AddAdditionalSkinsToSubrace("Illithid", "my_illithid_skin", 15, TIME_DAY);
//
// ::(Where "my_illithid_skin" is the resref of the skin you want equipped.)
//
// ::::
// :::: Remeber: If you say add a skin for a subrace to be equipped at level 15, then all PCs belonging to the
// :::: subrace above level 15 will also use the same skin for that time -unless you add a different skin for those levels.)
//
// ::::Use as many times as desired.
void AddAdditionalSkinsToSubrace(string subraceName, string SkinResRef, int EquipLevel, int iTime = TIME_BOTH);


//::: Add equipable creature claws to the subrace.  (Use as many times as desired)
//
// ::  This allows you to add 'Claws' to your subrace. You simply specify the Blue print resref of
// ::    the claw you want equipped on the player, and at what level.
// ::  (You can use this to equip claws/slams/gore or what ever else that maybe equipped in a PC's claw item slots
//
//
//:: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
//:: RightClawResRef: The resref of the right hand claw. (Use "" if you do not want to specify a claw, use "none" if you want any existing right claws to be removed from the player.)
//:: LeftClawResRef: The resref of the left hand claw.  (Use "" if you do not want to specify a claw, use "none" if you want any existing right claws to be removed from the player.)
//:: EquipLevel: The level at which these claws should be equipped.
//
// ::NOTE: 1. Make sure the PCs have weapon proficiency in creature weapons!!! I can't stress this enough.
// ::           (Give the feat through the subrace Skin)
//
// ::      2. If you are going to use one claw, make sure it is the right claw.
//
// ::      3. Also note that you need not change both claws at once.
// ::        (IE: Say you equipped a right and left claw at level 5, then say at level 10, if you want to change the left claw
// ::             then you only need to specify the resref of the left claw... the PC keeps the existing right claw.)
void AddClawsToSubrace(string subraceName, string RightClawResRef, string LeftClawResRef , int EquipLevel, int iTime = TIME_BOTH);


//::: Switch the player from one subrace to another ::::
//
// ::(Use only once per Level)
//
// :: This allows you to switch a player from one subrace to another.
//
//:: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
//:: switchSubraceName: The syntax of the subraces, you wish to switch the player (Should be the same as whatever the new subraces' name used in it's CreateSubrace())
//:: Level: The level at which this switch should take place.
//:: MustMeetRequirements: Set to FALSE, if you want the switching to bypass any class/race/alignment restriction the new subrace might have.
//
// ::  If MustMeetRequirements set to TRUE, and the character fails to meet a requirement... then they will continue on as part of their current sub-race.
//
// ::IDEA: You can set the subrace you want the player to switch to as a hidden and unaccessible subrace for new characters, by setting
// ::      PrestigiousSubrace to TRUE, in CreateSubrace().
// ::      That way, players must earn their way to this new subrace (switchSubraceNames).
//
// ::Note: Inorder for this to work the subrace you wish to switch the player to does NOT have to be marked as prestigious.
//
// ::IE: If I had set up three subraces like:
// ::    CreateSubrace(RACIAL_TYPE_HUMAN, "illithid", "sha_pc_illithid", "sha_subrace_illi", TRUE, 0, FALSE, 0, 3);
// ::    //(Along with other setting for subrace, like class restrictions, appearance, additional skins, etc)
//
// ::    CreateSubrace(RACIAL_TYPE_HUMAN, "vampire", "sha_pc_vamp001", "sha_subrace_vamp", TRUE, 2, FALSE, 0, 3, TRUE);
// ::    //Can only be evil.
// ::    CreateSubraceAlignmentRestriction("vampire", FALSE, FALSE, TRUE);
// ::    //(Along with other setting for subrace, like class restrictions, appearance, additional skins, etc)
//
// ::    CreateSubrace(RACIAL_TYPE_HUMAN, "wolkier", "sha_pc_wolk", "sha_subrace_wolk", TRUE);
// ::    //Can only be Neutra;.
// ::    CreateSubraceAlignmentRestriction("wolkier", FALSE, TRUE, FALSE);
// ::    //(Along with other setting for subrace, like class restrictions, appearance, additional skins, etc)
//
// ::And I wished that PCs belonging to illithid be switched to vampire or wolkier at level 15, depending on which criteria they meet, then I would call:
//
// :: SetupSubraceSwitch("illithid", "vampire_wolkier", 15, TRUE);
//
// ::If I didn't want the alignment criteria to be check during switching then I would call:
//
// ::  SetupSubraceSwitch("illithid", "vampire_wolkier", 15, FALSE);
//
// :: The order in which you choose the subrace to be switched is important. If the player can meet both requirements, it gives prioirty to the first one.
//
//
// :: You can put in any number of subraces to switch to..
// :: IE:
//        SetupSubraceSwitch("illithid", "vampire_wolkier_pixie_shadow", 8, TRUE);
//
// If a player doesn't meet the criteria for any one of the subraces, he/she wil remain part of thier usual subrace: subraceName.
//
// You can use SetupSwitchSubrace() as many times as you like. EG:
//
//   SetupSubraceSwitch("illithid", "vampire_wolkier_pixie_shadow", 12, TRUE);
//   SetupSubraceSwitch("illithid", "air-genasi_underminion", 18, TRUE);
//   SetupSubraceSwitch("illithid", "mindbreaker_telephathest_darkmoon", 32, TRUE);
//   SetupSubraceSwitch("illithid", "greatone", 40, FALSE);
//
// Where: vampire, wolkier, pixie, shadow, air-genasi, underminion, mindbreaker,
//        telephathest, darkmoon, and greatone are all subraces.
void SetupSubraceSwitch(string subraceName, string switchSubraceName, int Level, int MustMeetRequirements = TRUE);

// :: Give the player belonging to a subrace, additional unique items ::
//             (Use as many times as desired for any levels)
//
//    This allows you to give players belonging to a subrace additional unique items, at any level.
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: ItemResRef:  The blueprint res-ref of the item to give.
// :: Level:       The level at which to give the item.
//
// Example:
//
// Say I wanted to give my players belonging to the vampire subrace, an armour and a scythe at level 2.
// And then an amulet at level 10.
//       The armor's resref is: "sha_vamp_arm"
//       The scythe's resref is: "sha_vamp_scythe"
//       The amulet's resref is: "sha_vamp_ammy"
//
// So I simply call:
//    AddSubraceItem("vampire", "sha_vamp_arm", 2);
//    AddSubraceItem("vampire", "sha_vamp_scythe", 2);
//    AddSubraceItem("vampire", "sha_vamp_ammy", 10);
//
//// NOTE: You can only give ONE item of each. IE: You CAN'T do this expecting to give 2 amulets:
//
//   AddSubraceItem("vampire", "sha_vamp_ammy", 10);
//   AddSubraceItem("vampire", "sha_vamp_ammy", 10);
void AddSubraceItem(string subraceName, string ItemResRef, int Level = 1);





// :: Setup a Prestige class restriction for a 'Prestige' subrace.
//
// NOTE: This will only be checked during a 'subrace switch' for obvious reasons. Refer to SetupSubraceSwitch(...)
//
//    subraceName = Should be the same as the Subrace's name used in  CreateSubrace().
//    MinimumLevels = The minimum number of levels in a/any particular prestigious class allowed to pass the restriction.
//    Set CanBe_<Class> values as desired.
//
//    Example:
//
//    Say I have a subrace 'Phantasm' and I wanted to add a restriction so that only Shadow Dancers, Blackguards, and Assasin can be part of.
//    AND they must have atleast 5 levels in any of those classes.
//    So I set:
//
//    CreateSubracePrestigiousClassRestriction("phantasm", 5, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE);
//
//    * A player with class combination like <Any base class>/Assasin(2)/ShadowDancer(3) will meet this criteria.
//
//    NOTE: This can be used in combination with CreateSubraceClassRestriction(...)
//
//    If you wanted to you can also set-up a primary/base class restriction with CreateSubraceClassRestriction(...) and also create a Prestigious class restriction with this.
void CreateSubracePrestigiousClassRestriction(string subraceName, int MinimumLevels = 1, int CanBe_ArcaneArcher = TRUE, int CanBe_Assasin = TRUE, int CanBe_Blackguard = TRUE, int CanBe_ChampionOfTorm = TRUE, int CanBe_RedDragonDisciple = TRUE, int CanBe_DwarvenDefender = TRUE, int CanBe_HarperScout = TRUE, int CanBe_PaleMaster = TRUE, int CanBe_ShadowDancer = TRUE, int CanBe_Shifter = TRUE, int CanBe_WeaponMaster = TRUE);



//:: ----- LETO FUNCTION DEFINERS -------

// :: Add/remove a feat to/from the character belonging to a subrace ::
//
// >>> NEEDS LETO TO WORK (REFER TO THE .PDF GUIDE BOOK FOR MORE DETAILS
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: FeatID:  Use any FEAT_* constants.
// :: Remove: If set to TRUE, ti will remove the the feat from the player.
// :: Level: Level at which to give this bonus feat.
//
// NOTE: Player must have the required expansion packs for the feats. IE: If you were to give Epic Dodge,
//       the player must have HoTU expansion pack installed inorder to recieve/use the feat.
//
// Example of Useage:
//
// Say I want to give Disarm at level 5, and improved knockdown at level 8 to the players belonging to Drow subrace.
//  I also want to remove Alterness from the player at level 10.
//
//   ModifySubraceFeat("drow", FEAT_DISARM, 5);
//   ModifySubraceFeat("drow", FEAT_IMPROVED_KNOCKDOWN, 8);
//   ModifySubraceFeat("drow", FEAT_ALERTNESS, 10, TRUE);
//
//:: You may use this as many times as desired.
void ModifySubraceFeat(string subraceName, int FeatID, int Level = 1, int Remove = FALSE);


// :: Add wings or tail to the subrace ::
//
// >>> NEEDS LETO TO WORK (REFER TO THE .PDF GUIDE BOOK FOR MORE DETAILS
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: Male_Wings: The wing to be added for a male character: Use any  APPEARANCE_TYPE_ATTACHMENT_WINGS_* constant.
// :: Female_Wings: The wing to added for a female character: Use any  APPEARANCE_TYPE_ATTACHMENT_WINGS_* constant.
// :: Male_Tail: The tail to be added for a male character: Use any APPEARANCE_TYPE_ATTACHMENT_TAIL_* constant.
// :: Female_Tail: The tail to be added for a female character: Use any APPEARANCE_TYPE_ATTACHMENT_TAIL_* constant.
// :: Level: The level at which to add these attachments.
// NOTE: If you are using any of the CEP tails or wings, your server/module must have CEP.
//
// Example of Usage:
//
// Say I want to add bird like wings to the male character, and angel wings to the female character at level 21:
// I also want to change the male wings to devil and the female to red dragon disciple's, and add a bone tail to both genders at level 36.
//
//
//   AddSubraceAppearanceAttachment("mysubrace", APPEARANCE_TYPE_ATTACHMENT_WINGS_BIRD, APPEARANCE_TYPE_ATTACHMENT_WINGS_ANGEL, 0, 0, 21);
//   AddSubraceAppearanceAttachment("mysubrace", APPEARANCE_TYPE_ATTACHMENT_TAIL_DEVIL, APPEARANCE_TYPE_ATTACHMENT_WINGS_RED_DRAGON_DISCIPLE, APPEARANCE_TYPE_ATTACHMENT_TAIL_BONE, APPEARANCE_TYPE_ATTACHMENT_TAIL_BONE, 36);
//
//
//:: You may use this as many times as desired.
void ModifySubraceAppearanceAttachment(string subraceName, int Male_Wings = 0, int Female_Wings = 0, int Male_Tail = 0, int Female_Tail = 0, int Level = 1);


// :: Create custom base stats::
//
// >>> NEEDS LETO TO WORK (REFER TO THE .PDF GUIDE BOOK FOR MORE DETAILS
//
// :: This is used in conjunction with CreateBaseStatModifier(...) -refer to it for more details.
//
// :: --- Fill in the Modifiers as desired.
//         For speed modification use any  MOVEMENT_SPEED_* constant.
//
// Example: I want to increase Strength by 6, decrease Dexterity by 4, increase Consitution by 4, and change the movement speed to fast.
//          So I would call:
//
//       struct SubraceBaseStatsModifier MyStats = CustomBaseStatsModifiers(6, -4, 4, 0, 0, 0, MOVEMENT_SPEED_FAST);
struct SubraceBaseStatsModifier CustomBaseStatsModifiers(int StrengthModifier, int DexterityModifier, int ConstitutionModifier, int IntelligenceModifier, int WisdomModifier, int CharismaModifier, int MovementSpeedModifier);


// :: Use to make PERMANENT changes to the ability scores or movement speed of the character::
//
// >>> NEEDS LETO TO WORK (REFER TO THE .PDF GUIDE BOOK FOR MORE DETAILS
//
// :: This is used in conjunction with SubraceBaseStatsModifier CustomBaseStatsModifiers(...)
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: SubraceBaseStatsModifier Stats: Use CustomBaseStatsModifiers(...) to create the stats.
// :: Level: The level at which to make these changes.
// :: Set: If you set it to TRUE, then these stats will REPLACE (instead of adding or subtracting) the player's stats.
//
//
// Example of Useage:
// Say I have a subrace called: black-dragon.
//     And I want to increase Strength by 6, decrease Dexterity by 4, increase Consitution by 4,
//          and decrease charisma by 2, and change the movement speed to fast at level 10.
//
// So I would call:
//
//       struct SubraceBaseStatsModifier MyStats = CustomBaseStatsModifiers(6, -4, 4, 0, 0, -2, MOVEMENT_SPEED_FAST);
//       CreateBaseStatModifier("black-dragon", MyStats, 10);
//
// :: You may use this as many times as desired.
void CreateBaseStatModifier(string subraceName, struct SubraceBaseStatsModifier Stats, int Level = 1, int Set = FALSE);

// :: Use to the soundset of the character ::
//
// >>> NEEDS LETO TO WORK (REFER TO THE .PDF GUIDE BOOK FOR MORE DETAILS
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: MaleSoundSet: Refer to the table in the PDF guide book and enter the 'Reference Number'.
// :: FemaleSoundSet: Refer to the table in the PDF guide book and enter the 'Reference Number'.
// :: Level: The level at which to change the soundset.
//
// Example of Useage:
//     Say I want to change the Male character's soundset to Minotaur, Chief and the Female character's
//     soundset to Succubusat level 16. And then at level 25 change it to Ogre and Nymph.
//     >>> According to the table in the PDF guide book the numbers are 65 for Minotaur Chief, 90 for the Succubus,
//         70 for Ogre, and 197 for the Nymph soundsets).
//
//     ChangeSoundSet("mysubrace", 65, 90, 16);
//     ChangeSoundSet("mysubrace", 70, 197, 25);
//
// :: You may use this as many times as desired.
void ChangeSoundSet(string subraceName, int MaleSoundSet, int FemaleSoundSet, int Level = 1);

// :: Use to the portrait of a character ::
//
// >>> NEEDS LETO TO WORK (REFER TO THE .PDF GUIDE BOOK FOR MORE DETAILS
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: MalePortrait: Set the name of the male portrait.
// :: FemalePortrait: Set the name of the female portrait.
// :: Level: The level at which to change the portrait.
//
// List of portraits' file names can be found in portraits.2da.
//
// NOTE: This function will correclty set the portraits. But whether or not other players or the player him/herself can see
//       it depends on whether they have portrait in their portrait folder or the expansion packs containing the portraits.
//       (Like in the below for example: The Queen Shao's portrait is only included in HoTU. So if the player does not have Queen Shao's portraits in his/her
//        portrait folder will not be able to see them. And other players without HoTU will not be able to see the player's portrait)
//
// NOTE 2: If you want to use any of the standard portraits (That is any from NWN) make sure you have "po_" as prefix.
//         IE: If you want to use the portrait set 'el_f_04_' (as listed in portraits.2da) the actual name is: po_el_f_04_.
//         (Some portraits in the standard library do not use the po_ prefix.. and there is no way to tell other than by trial and error)
//
// Example of Useage:
//         Say I have the Queen Shao's portraits. These portraits are po_queenshao_h, po_queenshao_l, po_queenshao_m, po_queenshao_s, and po_queenshao_t.
//         So this means that this portrait set is refered to by: po_queenshao_
//         Likewise say I have another portrait set: my_male_port_
//
//         And say I want to set Queen Shao's portrait to all the female players, and my other portrait set to the male characters
//         at level 6. So I would call:
//
//    ChangePortrait("mysubrace", "po_queenshao_", "my_male_port_", 6);
//
// :: You may use this as many times as desired.
void ChangePortrait(string subraceName, string MalePortrait, string FemalePortrait, int Level = 1);



// :: Modify a skill a character belonging to a subrace has ::
//
// >>> NEEDS LETO TO WORK (REFER TO THE .PDF GUIDE BOOK FOR MORE DETAILS
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: SkillID: Use any  SKILL_* constants.
// :: iModifier: The value to increase or decrease or set the skill by/to.
// :: Set: If set to TRUE, the skill points in the chosen skill will be set to the value of iModifier.
//
// Example of Useage:
//
//    Say I want to increase Spot skill by 15, and decrease Search by 12 at level 10, and set Tumble to 5 at level 16.
//    I would call:
//
//    ModifySubraceSkill("mysubrace", SKILL_SPOT, 15, 10);
//    ModifySubraceSkill("mysubrace", SKILL_SEARCH, -12, 10);
//    ModifySubraceSkill("mysubrace", SKILL_TUMBLE, 5, 16, TRUE);
void ModifySubraceSkill(string subraceName, int SkillID, int iModifier, int Level = 1, int Set = FALSE);




// :: Use to set-up an automated change in the subrace's faction ::
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: FactionCreatureTag: The tag of the creature whose perception of the subrace will be adjusted.
// :: Reputation: Use any  SUBRACE_FACTION_REPUTATION_* constants.
//
// Refer to the .PDF Guide book for a detailed example, and implementation of this function.
//
// Example of function usage:
//
//   Say I have a NPC faction called 'Drow Faction'. This faction will normally attack
//   (Hostile) player character. But I want to have the players belonging to the 'Drow' subrace
//   be treated friendly, by the NPCs belonging to this faction...
//
//   So inorder to do this; first I will need to create:
//   An NPC in a LOCKED room (IE: no player can enter), I would remove all weapons and items from this
//   NPC.
//   Set it as Immortal (NOT Plot).
//   Set it's tag to say: MY_DROW_FACTION_NPC
//   And then call this function:
//
//     ModifySubraceFaction("drow", "MY_DROW_FACTION_NPC", SUBRACE_FACTION_REPUTATION_FRIENDLY);
void ModifySubraceFaction(string subraceName, string FactionCreatureTag, int Reputation = SUBRACE_FACTION_REPUTATION_HOSTILE);

// :: Setup a start location for a subrace ::
//
// :: subraceName: Should be the same as the Subrace's name used in  CreateSubrace()
// :: WaypointTag: The Tag of the waypoint to which the player will be ported to.
//
//
// This will teleport the player belonging to the Subrace 'subraceName' to
// the waypoint, when they enter the module.
void CreateSubraceStartLocation(string subraceName, string WaypointTag);









/*
:::::::::::::::::::::::: Function Definers usuable anywhere ::::::::::::::::::::
*/
//:: You may use these functions anywhere, and they would work appropriately.


// ::Erases all "temporary" subracial abilities, so that after respawn or a restoring spell is cast
// ::the heartbeat script will then reapply the stats again.
void ReapplySubraceAbilities(object oPC);

//Add this on the Module OnClientEnter script.
void SubraceOnClientEnter();

//Add this to Module OnPlayerRespawn script.
void SubraceOnPlayerRespawn();

//Add this to Module OnPlayerLevelUp script.
void SubraceOnPlayerLevelUp();

//Add this to Module OnPlayerEquipItem script.
void SubraceOnPlayerEquipItem();

//Add this to the Module OnItemActivated script.
void SubraceOnItemActivated();

//Subrace Heartbeat function - For use in default.nss
void SubraceHeartbeat(object oPC = OBJECT_SELF);

//Add this to the Module OnClientLeave script.
void SubraceOnClientLeave();

//:: Force the player to properly un-equip the item.
void SHA_SubraceForceUnequipItem(object oItem);

//:: Force the player to properly equip oItem in the inventory slot: InvoSlot.
void SHA_SubraceForceEquipItem(object oItem, int InvoSlot);

//Return the XP modifier for being part of the Subrace
//(Calclates modifer value for Subrace Favored classes)
float GetSubraceXPModifier(object oPC);

//:: Returns TRUE if the player is marked as being part of an undead subrace.
//:: (Shayan's Subrace Engine)
int Subrace_GetIsUndead(object oPC);

//:: Returns the Effective Character level of oPC.
//:: (Shayan's Subrace Engine)
int GetECL(object oPC);

//:: Deletes every bit of subracial information stored on the PC. Also destroys equipped skins and claws.
//:: (Does not however delete the 'subrace' set on the PC. Use SetSubRace(oPC, "") AFTER calling this, if you wish to remove the PC from the subrace completely.)
//:: (Shayan's Subrace Engine)
void DeleteSubraceInfoOnPC(object oPC);

//:: Change the PC to his/her default humaniod appearance.
//:: IE: If the player is human and his/her appearance is Illithid, this will turn them back
//::     to looking like human again.
//:: (Shayan's Subrace Engine)
void ChangeToPCDefaultAppearance(object oPC);


//:: Returns TRUE if PC belongs to a subrace which is Light sensitive.
//:: (Shayan's Subrace Engine)
int GetIsPCLightSensitive(object oPC);

//:: Reads al the subraces avaliable in this module to the object oDM.
//:: (Shayan's Subrace Engine)
void ReadAllSubraces(object oDM);

//:: Return the Favored class of the PC. Returns -1 if there is none.
//:: (Shayan's Subrace Engine)
int Subrace_GetFavouredClass(object oPC);

//:: Send's a message to PC, with a Subrace Engine title. Set Important to TRUE if
//:: it is an important message. (Refer to sha_subr_consts for more info.)
//:: (Shayan's Subrace Engine)
void SHA_SendSubraceMessageToPC(object oPC, string message, int Important = TRUE);

//:: Traverses through oPC's inventory, destroying all Skins, and creature items.
void SearchAndDestroySkinsAndClaws(object oPC);

//:: Removes temporary subrace ability scores and AB boosts.
void ClearSubraceEffects(object oPC);

//:: Returns TIME_DAY, or TIME_NIGHT depending on the current hour of day.
int SHA_GetCurrentTime();

//:: Returns the default appearance type of oPC. (It ignores any appearance
//:: change by SetAppearance()).
//:: NOTE: oPC must be a player character in order for this to work.
int SHA_GetDefaultAppearanceType(object oPC);





//
//::::::::::::::::::::::::: Interal Function definers:::::::::::::::::::::::::::
//
// :: Do not use these functions outside this script. They may not work correctly.

void SaveSubraceOnModule(struct Subrace shaSubrace);
void GiveSubraceUniqueItem(string SubraceTag, object oPC);
void SaveSubraceAlignmentRestrictionOnModule(struct SubraceAlignmentRestriction shaSubraceAlignRes);
void SaveSubraceClassRestrictionOnModule(struct SubraceClassRestriction shaSubraceClassRes);
void SaveSubraceSpellResistanceOnModule(struct SubraceSpellResistance shaSubraceSpellRes);
void SaveSubraceAppearanceChangeOnModule(struct SubraceDifferentAppearance shaSubraceApp);
int CheckIfPCMeetsClassCriteria(object oPC, string SubraceTag);
int CheckIfPCMeetsAlignmentCriteria(object oPC, string SubraceTag);
int CheckIfPCMeetsAnySubraceCriteria(object oPC);
void SHA_ApplyTemporaryStats(object oPC, string SubraceTag, int iCurrentTime, int iTimeDay, int iTimeNight,int AreaUndAbove, int AreaIntExt, int AreaNatArt);
void ApplyTemporarySubraceStats(object oPC, string SubraceTag, int iCurrentTime, int AreaUndAbove, int AreaIntExt, int AreaNatArt);
void ApplyStat_AbilityByPercentage(int AbilityToMod, float percentage, object oPC);
void ApplySubraceBonusStatsByPercentage(object oPC, string SubraceTag);
void ApplyAttackBonusByPercentage(float percentage, object oPC);
void ApplyArmourClassBonusByPercentage(float percentage, object oPC);
void ApplySubraceBonusStatsByPoints(object oPC, string SubraceTag);
void ApplyStat_AbilityByPoints(int AbilityToMod, float points, object oPC);
void ApplyAttackBonusByPoints(float points, object oPC);
void ApplyArmourClassBonusByPoints(float points, object oPC);
void ClearSubraceTemporaryStats(object oPC);
void LoadSubraceInfoOnPC(object oPC, string subraceName);
void ApplyPermanentSubraceSpellResistance(string subrace, object oPC);
void InitiateSubraceChecking(object oPC);
int GetFavoredClassExceedsGap(int Race1Favored, int Race2Favored, int Class1, int Class2, int Class3, int Class13Gap, int Class23Gap, int Class12Gap);
void ApplySubraceEffect(object oPC, string SubraceTag, int TimeOfDay);
void CheckIfCanUseEquipedWeapon(object oPC);
void ReadSubraceInformation(string subraceName, object oDM, object oTarget = OBJECT_INVALID);
void ReadSubrace(object oDM, int MaxCount, int CurrentCount);
void EquipTemporarySubraceClaw(string subraceTag, object oPC, int iTime);
void EquipTemporarySubraceSkin(string subraceTag, object oPC, int iTime);
void CheckAndSwitchSubrace(object oPC);
void SubraceCheckItemActivated(object oPC, object oItem);
string Subrace_DefenseRestrictionToString(int ResType);
string Subrace_WeaponRestrictionToString(int ResType);
string Subrace_TimeToString(int iTime);
int CheckIfPCMeetsPrestigiousClassCriteria(object oPC, string SubraceTag);
string CheckAndModifyAttachments(object oPC, string SubraceTag, int Level);
int CheckForLetoReLog(object oPC, int Level);
string CheckAndModifyBaseStats(object oPC, string SubraceTag, int Level);
string CheckAndModifySkills(object oPC, string SubraceTag, int Level);
string CheckAndModifyFeats(object oPC, string SubraceTag, int Level);
string CheckAndModifyPortrait(object oPC, string SubraceTag, int Level);
string CheckAndModifySoundSet(object oPC, string SubraceTag, int Level);
void DelayBoot(object oPC);
void Subrace_FactionAdjustment(object oPC, string FactionTag, int Adjustment);
void ChangeSubraceFactions(object oPC, string SubraceTag);
void Subrace_MoveToStartLocation(object oPC, string subrace);
void SetSubraceDBInt(string sCampaignName, string sVarName, int nInt, object oPlayer=OBJECT_INVALID);
int GetSubraceDBInt(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID);


//:: ---------------------------------------------------------------------------
//:: Functions for the Subrace Engine.
//:: ---------------------------------------------------------------------------


void SetSubraceDBInt(string sCampaignName, string sVarName, int nInt, object oPlayer=OBJECT_INVALID)
{
    if(ENABLE_NWNX_DATABASE)
    {
       // SetPersistentInt(oPlayer, sVarName, nInt, sCampaignName);
    }
    else
    {
       SetCampaignInt(sCampaignName, sVarName, nInt, oPlayer);
    }

}

int GetSubraceDBInt(string sCampaignName, string sVarName, object oPlayer=OBJECT_INVALID)
{
    int iInt;
    if(ENABLE_NWNX_DATABASE)
    {
       //iInt = GetPersistentInt(oPlayer, sVarName, sCampaignName);
    }
    else
    {
       iInt = GetCampaignInt(sCampaignName, sVarName, oPlayer);
    }
    return iInt;
}

void SHA_SendSubraceMessageToPC(object oPC, string message, int Important = TRUE)
{
   if(MINIMALISE_SUBRACE_MESSAGES_TO_PC)
   {
      if(Important)
      {
         SendMessageToPC(oPC, SUBRACE_ENGINE + message);
      }
   }
   else
   {
      SendMessageToPC(oPC, SUBRACE_ENGINE + message);
   }
}


void CreateSubrace(int Race, string SubraceName, string HideResRef = "", string UniqueItemResRef = "", int IsLightSensitive = FALSE, int DamageTakenWhileInLight = 0, int IsUndergroundSensitive = FALSE, int DamageTakenWhileInUnderground = 0, int ECL = 0, int IsUndead = FALSE, int PrestigiousSubrace = FALSE)
{
    struct Subrace shaSubrace;

    shaSubrace.BaseRace = Race;
    shaSubrace.Name = SubraceName;
    shaSubrace.SkinResRef = HideResRef;
    shaSubrace.UniqueItemResRef =  UniqueItemResRef;
    shaSubrace.IsLightSensitive = IsLightSensitive;
    shaSubrace.DamageTakenWhileInLight = DamageTakenWhileInLight;
    shaSubrace.IsUndergroundSensitive = IsUndergroundSensitive;
    shaSubrace.DamageTakenWhileInUnderground = DamageTakenWhileInUnderground;
    shaSubrace.ECL = ECL;
    shaSubrace.IsUndead = IsUndead;
    shaSubrace.PrestigiousSubrace = PrestigiousSubrace;

    SaveSubraceOnModule(shaSubrace);
}

void CreateSubraceAlignmentRestriction(string subraceName, int CanBeAlignment_Good = TRUE , int CanBeAlignment_Neutral1 = TRUE, int CanBeAlignment_Evil = TRUE, int CanBeAlignment_Lawful = TRUE, int CanBeAlignment_Neutral2 = TRUE, int CanBeAlignment_Chaotic = TRUE)
{
    struct SubraceAlignmentRestriction shaSubraceAlignRes;

    shaSubraceAlignRes.subraceName = subraceName;
    shaSubraceAlignRes.CanBeAlignment_Good = CanBeAlignment_Good;
    shaSubraceAlignRes.CanBeAlignment_Neutral1 = CanBeAlignment_Neutral1;
    shaSubraceAlignRes.CanBeAlignment_Evil =CanBeAlignment_Evil;
    shaSubraceAlignRes.CanBeAlignment_Lawful = CanBeAlignment_Lawful;
    shaSubraceAlignRes.CanBeAlignment_Neutral2 = CanBeAlignment_Neutral2;
    shaSubraceAlignRes.CanBeAlignment_Chaotic = CanBeAlignment_Chaotic;

    SaveSubraceAlignmentRestrictionOnModule(shaSubraceAlignRes);
}

void CreateSubraceClassRestriction(string subraceName, int CanBe_Barbarian = TRUE, int CanBe_Bard = TRUE, int CanBe_Cleric = TRUE, int CanBe_Druid = TRUE, int CanBe_Fighter = TRUE, int CanBe_Monk = TRUE, int CanBe_Paladin = TRUE, int CanBe_Ranger = TRUE, int CanBe_Rogue = TRUE, int CanBe_Sorcerer = TRUE, int CanBe_Wizard = TRUE)
{
    struct SubraceClassRestriction shaSubraceClassRes;

    shaSubraceClassRes.subraceName = subraceName;

    shaSubraceClassRes.CanBe_Barbarian = CanBe_Barbarian;
    shaSubraceClassRes.CanBe_Bard = CanBe_Bard;
    shaSubraceClassRes.CanBe_Cleric = CanBe_Cleric;
    shaSubraceClassRes.CanBe_Druid = CanBe_Druid;
    shaSubraceClassRes.CanBe_Fighter = CanBe_Fighter;
    shaSubraceClassRes.CanBe_Monk = CanBe_Monk;
    shaSubraceClassRes.CanBe_Paladin = CanBe_Paladin;
    shaSubraceClassRes.CanBe_Ranger = CanBe_Ranger;
    shaSubraceClassRes.CanBe_Rogue = CanBe_Rogue;
    shaSubraceClassRes.CanBe_Sorcerer = CanBe_Sorcerer;
    shaSubraceClassRes.CanBe_Wizard = CanBe_Wizard;

    SaveSubraceClassRestrictionOnModule(shaSubraceClassRes);
}

void CreateSubraceSpellResistance(string subraceName, int SpellResistanceBase, int SpellResistanceMax)
{
   struct SubraceSpellResistance shaSubraceSpellRes;

   shaSubraceSpellRes.subraceName = subraceName;
   shaSubraceSpellRes.SpellResistanceBase = SpellResistanceBase;
   shaSubraceSpellRes.SpellResistanceMax = SpellResistanceMax;

   SaveSubraceSpellResistanceOnModule(shaSubraceSpellRes);
}

void CreateSubraceAppearance(string subraceName, int AppearanceChangeTime, int MaleAppearance, int FemaleAppearance, int Level = 1)
{
   struct SubraceDifferentAppearance shaSubraceApp;

   shaSubraceApp.subraceName = subraceName;
   shaSubraceApp.ChangeAppearanceTime = AppearanceChangeTime;
   shaSubraceApp.MaleAppearance = MaleAppearance;
   shaSubraceApp.FemaleAppearance = FemaleAppearance;
   shaSubraceApp.Level = Level;

   SaveSubraceAppearanceChangeOnModule(shaSubraceApp);
}



void AddAdditionalBaseRaceToSubrace(string subraceName, int AdditionalBaseRace)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   int Flag = NOFLAGS;
   switch(AdditionalBaseRace)
   {
      case RACIAL_TYPE_DWARF: Flag = FLAG1; break;
      case RACIAL_TYPE_ELF:  Flag = FLAG2;  break;
      case RACIAL_TYPE_GNOME: Flag = FLAG3;  break;
      case RACIAL_TYPE_HALFELF: Flag = FLAG4;   break;
      case RACIAL_TYPE_HALFLING: Flag = FLAG5;  break;
      case RACIAL_TYPE_HALFORC: Flag = FLAG6;  break;
      case RACIAL_TYPE_HUMAN: Flag = FLAG7;  break;
      case RACIAL_TYPE_ALL:  Flag = ALLFLAGS;  break;
      default: Flag = NOFLAGS;  break;
   }
   SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, Flag, SUBRACE_BASE_RACE_FLAGS);
}

void AddSubraceEffect(string subraceName, int EffectID, int Value1, int Value2, int nDurationType, float fDuration, int TimeOfDay)
{
  subraceName = GetStringLowerCase(subraceName);
  string SubraceTag = SUBRACE_TAG + "_" + subraceName;
  int Count = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_EFFECT_COUNT);
  Count++;
  SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_EFFECT_COUNT, Count);
  SubraceTag = SubraceTag + IntToString(Count);
  SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_EFFECT, EffectID);
  SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_EFFECT_VALUE_1, Value1);
  SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_EFFECT_VALUE_2, Value2);
  SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_EFFECT_DURATION_TYPE, nDurationType);
  SetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_EFFECT_DURATION, fDuration);
  SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_EFFECT_APPLY_TIME, TimeOfDay);
}

void AddSubraceFavoredClass(string subraceName, int MaleFavoredClass, int FamaleFavoredClass)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_FAVORED_CLASS, MaleFavoredClass + 1, SUBRACE_FAVORED_CLASS_MALE_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_FAVORED_CLASS, FamaleFavoredClass + 1, SUBRACE_FAVORED_CLASS_FEMALE_FLAG);
}

void CreateSubracePrestigiousClassRestriction(string subraceName, int MinimumLevels = 1, int CanBe_ArcaneArcher = TRUE, int CanBe_Assasin = TRUE, int CanBe_Blackguard = TRUE, int CanBe_ChampionOfTorm = TRUE, int CanBe_RedDragonDisciple = TRUE, int CanBe_DwarvenDefender = TRUE, int CanBe_HarperScout = TRUE, int CanBe_PaleMaster = TRUE, int CanBe_ShadowDancer = TRUE, int CanBe_Shifter = TRUE, int CanBe_WeaponMaster = TRUE)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;

   SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION_MINIMUM_LEVELS, MinimumLevels);
   //Flags
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG1, TRUE);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG2, CanBe_ArcaneArcher);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG3, CanBe_Assasin);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG4, CanBe_Blackguard);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG5, CanBe_ChampionOfTorm);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG6, CanBe_RedDragonDisciple);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG7, CanBe_DwarvenDefender);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG8, CanBe_PaleMaster);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG9, CanBe_ShadowDancer);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG10, CanBe_Shifter);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG11, CanBe_WeaponMaster);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG12, CanBe_HarperScout);
}

void CreateTemporaryStatModifier(string subraceName, struct SubraceStats Stats, int TimeToApply, int InInteriorArea = TRUE, int InExteriorArea = TRUE, int InNaturalArea = TRUE, int InArtifacialArea = TRUE, int InUndergroundArea = TRUE, int InAbovegroundArea = TRUE)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG1, TRUE);

   if(TimeToApply == TIME_DAY)
   {
      SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG2, TRUE);
   }
   else if(TimeToApply == TIME_NIGHT)
   {
        SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG3, TRUE);
   }

   int ModType = Stats.ModType;
   float StrengthModifier = Stats.StrengthModifier;
   float DexterityModifier = Stats.DexterityModifier;
   float ConstitutionModifier = Stats.ConstitutionModifier;
   float IntelligenceModifier = Stats.IntelligenceModifier;
   float WisdomModifier = Stats.WisdomModifier;
   float CharismaModifier = Stats.CharismaModifier;
   float ACModifier = Stats.ACModifier;
   float ABModifier = Stats.ABModifier;

   SubraceTag = SubraceTag + IntToString(TimeToApply);

   SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIER_TYPE, ModType);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG4, InInteriorArea);
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG5, InExteriorArea);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG6, InArtifacialArea);
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG7, InNaturalArea);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG8, InAbovegroundArea);
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG9, InUndergroundArea);

   SetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER, StrengthModifier);
   SetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER, DexterityModifier);
   SetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER, ConstitutionModifier);
   SetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER, WisdomModifier);
   SetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER, IntelligenceModifier);
   SetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER, CharismaModifier);

   SetLocalFloat(oStorer, SubraceTag  + "_" + SUBRACE_STAT_AB_MODIFIER, ABModifier);
   SetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER, ACModifier);
}


//For StatModiferType use only SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE or SUBRACE_STAT_MODIFIER_TYPE_POINTS
struct SubraceStats CreateCustomStats(int StatModifierType, float StrengthModifier, float DexterityModifier, float ConstitutionModifier, float IntelligenceModifier, float WisdomModifier, float CharismaModifier, float ACModifier, float ABModifier)
{
  struct SubraceStats Stats;
  Stats.ModType =  StatModifierType;
  Stats.StrengthModifier = StrengthModifier;
  Stats.DexterityModifier = DexterityModifier;
  Stats.ConstitutionModifier = ConstitutionModifier;
  Stats.IntelligenceModifier  =  IntelligenceModifier;
  Stats.WisdomModifier =  WisdomModifier;
  Stats.CharismaModifier =  CharismaModifier;
  Stats.ACModifier =  ACModifier;
  Stats.ABModifier =  ABModifier;
  return Stats;
}


void SubraceRestrictUseOfWeaponsOfType(string subraceName, int WeaponType, int TimeOfDay = TIME_BOTH, int Allow = FALSE)
{
   //Why bother adding a restriction if you are going to allow the use of all weapons?!
   if(WeaponType == SUBRACE_RESTRICTION_WEAPON_ALL && Allow)
   { return; }
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;

   SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_ALLOW_ONLY_THIS_TYPE, SUBRACE_RESTRICTION_FLAGS, Allow);
   SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_HAS_RESTRICTION, SUBRACE_RESTRICTION_FLAGS);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, WeaponType, SUBRACE_RESTRICTION_WEAPON);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, TimeOfDay, TIME_FLAGS);
}

void SubraceRestrictUseOfArmourAndShieldsOfType(string subraceName, int Type, int TimeOfDay = TIME_BOTH, int Allow = FALSE)
{
   //Why bother adding a restriction if you are going to allow the use of all armour?!
   if(Type == SUBRACE_RESTRICTION_DEFENSE_ALL && Allow)
   { return; }
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;

   SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, SUBRACE_ALLOW_ONLY_THIS_TYPE, SUBRACE_RESTRICTION_FLAGS, Allow);
   SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, SUBRACE_HAS_RESTRICTION, SUBRACE_RESTRICTION_FLAGS);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, Type, SUBRACE_RESTRICTION_DEFENSE);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, TimeOfDay, TIME_FLAGS);

}

void SetupSubraceSwitch(string subraceName, string switchSubraceNames, int Level, int MustMeetRequirements = TRUE)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   SetLocalString(oStorer, SubraceTag + "_" + SUBRACE_SWITCH_NAME + IntToString(Level), switchSubraceNames);
   if(MustMeetRequirements)
   {
      SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_SWITCH_MUST_MEET_REQUIREMENTS + IntToString(Level), TRUE);
   }
}



//:: Internal Functions
void SaveSubraceOnModule(struct Subrace shaSubrace)
{

    string subraceName = GetStringLowerCase(shaSubrace.Name);
    string SubraceTag = SUBRACE_TAG + "_" + subraceName;
    SetLocalInt(oStorer, SubraceTag, TRUE);
    //Save the count, and the name of the subrace.
    int iCount = GetLocalInt(oStorer, MODULE_SUBRACE_COUNT);
    iCount++;
    SetLocalInt(oStorer, MODULE_SUBRACE_COUNT, iCount);
    SetLocalString(oStorer, MODULE_SUBRACE_NUMBER + IntToString(iCount), subraceName);


    int Flag = NOFLAGS;
    switch(shaSubrace.BaseRace)
    {
      case RACIAL_TYPE_DWARF: Flag = FLAG1; break;
      case RACIAL_TYPE_ELF:  Flag = FLAG2;  break;
      case RACIAL_TYPE_GNOME: Flag = FLAG3;  break;
      case RACIAL_TYPE_HALFELF: Flag = FLAG4;   break;
      case RACIAL_TYPE_HALFLING: Flag = FLAG5;  break;
      case RACIAL_TYPE_HALFORC: Flag = FLAG6;  break;
      case RACIAL_TYPE_HUMAN: Flag = FLAG7;  break;
      case RACIAL_TYPE_ALL:  Flag = ALLFLAGS;  break;
      default: Flag = NOFLAGS;  break;
    }
    SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, Flag, SUBRACE_BASE_RACE_FLAGS);

    if(shaSubrace.SkinResRef != "none" && shaSubrace.SkinResRef != "")
    {
        SetLocalString(oStorer, SubraceTag + "_" + SUBRACE_SKIN + "_1" + "_" + IntToString(TIME_BOTH), shaSubrace.SkinResRef);
    }
    if(shaSubrace.UniqueItemResRef != "" && shaSubrace.UniqueItemResRef != "none")
    {
        int SubraceUniqueItemCount = 1;
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_UNIQUEITEM_COUNT, SubraceUniqueItemCount);
        SetLocalString(oStorer, SubraceTag + "_" + SUBRACE_UNIQUEITEM + "_1", shaSubrace.UniqueItemResRef + "_1");
    }
    SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS, shaSubrace.IsLightSensitive);
    SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS, shaSubrace.IsUndergroundSensitive);
    SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDEAD, SUBRACE_BASE_INFORMATION_FLAGS, shaSubrace.IsUndead);
    SetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_PRESTIGIOUS_SUBRACE, SUBRACE_BASE_INFORMATION_FLAGS, shaSubrace.PrestigiousSubrace);

    if(shaSubrace.DamageTakenWhileInLight != 0)
    {
        SetLocalInt(oStorer, SubraceTag + "_" + DAMAGE_AMOUNT_IN_LIGHT, shaSubrace.DamageTakenWhileInLight);
    }

    if(shaSubrace.DamageTakenWhileInUnderground != 0)
    {
        SetLocalInt(oStorer, SubraceTag + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND, shaSubrace.DamageTakenWhileInUnderground);
    }
    if(shaSubrace.ECL != 0)
    {
       SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, shaSubrace.ECL,  SUBRACE_BASE_INFORMATION_ECL);
    }

}

void SaveSubraceAlignmentRestrictionOnModule(struct SubraceAlignmentRestriction shaSubraceAlignRes)
{
   string subraceName = GetStringLowerCase(shaSubraceAlignRes.subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG1, TRUE);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG2, shaSubraceAlignRes.CanBeAlignment_Good);
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG3, shaSubraceAlignRes.CanBeAlignment_Neutral1);
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG4, shaSubraceAlignRes.CanBeAlignment_Evil);
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG5, shaSubraceAlignRes.CanBeAlignment_Lawful);
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG6, shaSubraceAlignRes.CanBeAlignment_Neutral2);
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG7, shaSubraceAlignRes.CanBeAlignment_Chaotic);

}

void SaveSubraceClassRestrictionOnModule(struct SubraceClassRestriction shaSubraceClassRes)
{

   string subraceName = GetStringLowerCase(shaSubraceClassRes.subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   //Flags
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG1, TRUE);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG2, shaSubraceClassRes.CanBe_Barbarian);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG3, shaSubraceClassRes.CanBe_Bard);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG4, shaSubraceClassRes.CanBe_Cleric);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG5, shaSubraceClassRes.CanBe_Druid);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG6, shaSubraceClassRes.CanBe_Fighter);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG7, shaSubraceClassRes.CanBe_Monk);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG8, shaSubraceClassRes.CanBe_Paladin);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG9, shaSubraceClassRes.CanBe_Ranger);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG10, shaSubraceClassRes.CanBe_Rogue);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG11, shaSubraceClassRes.CanBe_Sorcerer);

   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG12, shaSubraceClassRes.CanBe_Wizard);
}

void SaveSubraceSpellResistanceOnModule(struct SubraceSpellResistance shaSubraceSpellRes)
{
   string subraceName = GetStringLowerCase(shaSubraceSpellRes.subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;

   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_SPELL_RESISTANCE, shaSubraceSpellRes.SpellResistanceBase,SUBRACE_SPELL_RESISTANCE_BASE_FLAGS);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_SPELL_RESISTANCE, shaSubraceSpellRes.SpellResistanceMax, SUBRACE_SPELL_RESISTANCE_MAX_FLAGS);
}

void SaveSubraceAppearanceChangeOnModule(struct SubraceDifferentAppearance shaSubraceApp)
{
   string subraceName = GetStringLowerCase(shaSubraceApp.subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   SubraceTag = SubraceTag + "_" + IntToString(shaSubraceApp.Level);
   SetLocalGroupFlag(oStorer, SubraceTag + "_" + APPEARANCE_CHANGE, shaSubraceApp.ChangeAppearanceTime, TIME_FLAGS);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + APPEARANCE_TO_CHANGE, shaSubraceApp.MaleAppearance, APPEARANCE_CHANGE_MALE_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + APPEARANCE_TO_CHANGE, shaSubraceApp.FemaleAppearance, APPEARANCE_CHANGE_FEMALE_FLAG);
}

void AddAdditionalSkinsToSubrace(string subraceName, string SkinResRef, int EquipLevel, int iTime = TIME_BOTH)
{
    subraceName = GetStringLowerCase(subraceName);
    string SubraceTag = SUBRACE_TAG + "_" + subraceName;
    SetLocalString(oStorer, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(EquipLevel) + "_" + IntToString(iTime), SkinResRef);
}

void AddClawsToSubrace(string subraceName, string RightClawResRef, string LeftClawResRef , int EquipLevel, int iTime = TIME_BOTH)
{
    subraceName = GetStringLowerCase(subraceName);
    string SubraceTag = SUBRACE_TAG + "_" + subraceName;
    if(RightClawResRef != "")
    {
        SetLocalString(oStorer, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(EquipLevel) + "_" + IntToString(iTime), RightClawResRef);
    }
    if(LeftClawResRef != "")
    {
        SetLocalString(oStorer, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(EquipLevel) + "_" + IntToString(iTime), LeftClawResRef);
    }
}
void AddSubraceItem(string subraceName, string ItemResRef, int Level = 1)
{
    subraceName = GetStringLowerCase(subraceName);
    string SubraceTag = SUBRACE_TAG + "_" + subraceName;
    int SubraceUniqueItemCount = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_UNIQUEITEM_COUNT);
    SubraceUniqueItemCount++;
    SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_UNIQUEITEM_COUNT, SubraceUniqueItemCount);

    SetLocalString(oStorer, SubraceTag + "_" + SUBRACE_UNIQUEITEM + "_" + IntToString(SubraceUniqueItemCount), ItemResRef + "_" + IntToString(Level));
}




//LETO STUFF
struct SubraceBaseStatsModifier CustomBaseStatsModifiers(int StrengthModifier, int DexterityModifier, int ConstitutionModifier, int IntelligenceModifier, int WisdomModifier, int CharismaModifier, int MovementSpeedModifier)
{
  struct SubraceBaseStatsModifier Stats;
  Stats.StrengthModifier = StrengthModifier;
  Stats.DexterityModifier = DexterityModifier;
  Stats.ConstitutionModifier = ConstitutionModifier;
  Stats.IntelligenceModifier  =  IntelligenceModifier;
  Stats.WisdomModifier =  WisdomModifier;
  Stats.CharismaModifier =  CharismaModifier;
  Stats.SpdModifier =  MovementSpeedModifier;
//  Stats.HPModifier = HPModifier;
  return Stats;
}

void CreateBaseStatModifier(string subraceName, struct SubraceBaseStatsModifier Stats, int Level = 1, int Set = FALSE)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;

   int StrengthModifier = Stats.StrengthModifier;
   int DexterityModifier = Stats.DexterityModifier;
   int ConstitutionModifier = Stats.ConstitutionModifier;
   int IntelligenceModifier = Stats.IntelligenceModifier;
   int WisdomModifier = Stats.WisdomModifier;
   int CharismaModifier = Stats.CharismaModifier;
   int SpdModifier = Stats.SpdModifier;
   //int HPModifier = Stats.HPModifier;

   SubraceTag = SubraceTag + "_" + IntToString(Level);
   SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_HAS_BASE_STAT_MODIFIERS, TRUE);
   if(Set)
   {
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BASE_STAT_MODIFIERS_REPLACE, Set);
   }
   if(StrengthModifier != 0)
   {
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BASE_STAT_STR_MODIFIER, StrengthModifier);
   }
   if(DexterityModifier != 0)
   {
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BASE_STAT_DEX_MODIFIER, DexterityModifier);
   }
   if(ConstitutionModifier != 0)
   {
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BASE_STAT_CON_MODIFIER, ConstitutionModifier);
   }
   if(WisdomModifier != 0)
   {
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BASE_STAT_WIS_MODIFIER, WisdomModifier);
   }
   if(IntelligenceModifier != 0)
   {
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BASE_STAT_INT_MODIFIER, IntelligenceModifier);
   }
   if(CharismaModifier != 0)
   {
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BASE_STAT_CHA_MODIFIER, CharismaModifier);
   }

   if(SpdModifier != 0)
   {
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BASE_STAT_SPD_MODIFIER, SpdModifier);
   }
  /* if(HPModifier != 0)
   {
        SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BASE_STAT_HP_MODIFIER, HPModifier);
   }  */
}

void ModifySubraceFaction(string subraceName, string FactionCreatureTag, int Reputation = SUBRACE_FACTION_REPUTATION_HOSTILE)
{
    subraceName = GetStringLowerCase(subraceName);
    string SubraceTag = SUBRACE_TAG + "_" + subraceName;
    int Count =  GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_FACTION_COUNT);
    Count++;
    SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_FACTION_COUNT, Count);
    SetLocalString(oStorer, SubraceTag + "_" + SUBRACE_FACTION_CREATURE + "_" + IntToString(Count), FactionCreatureTag);
    SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_FACTION_REPUTATION + "_" + IntToString(Count), Reputation);
}

void CreateSubraceStartLocation(string subraceName, string WaypointTag)
{
  subraceName = GetStringLowerCase(subraceName);
  string SubraceTag = SUBRACE_TAG + "_" + subraceName;
  SetLocalString(oStorer, SubraceTag + "_" + SUBRACE_START_LOCATION, WaypointTag);
}


void ModifySubraceAppearanceAttachment(string subraceName, int Male_Wings = 0, int Female_Wings = 0, int Male_Tail = 0, int Female_Tail = 0, int Level = 1)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   SubraceTag = SubraceTag + "_" + IntToString(Level);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_ATTACHMENT_FLAGS, Male_Wings, SUBRACE_ATTACHMENT_FLAGS_WINGS_MALE);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_ATTACHMENT_FLAGS, Female_Wings, SUBRACE_ATTACHMENT_FLAGS_WINGS_FEMALE);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_ATTACHMENT_FLAGS, Male_Tail, SUBRACE_ATTACHMENT_FLAGS_TAIL_MALE);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_ATTACHMENT_FLAGS, Female_Tail, SUBRACE_ATTACHMENT_FLAGS_TAIL_FEMALE);
}

void ModifySubraceFeat(string subraceName, int FeatID, int Level = 1, int Remove = FALSE)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   SubraceTag = SubraceTag + "_" + IntToString(Level);
   int FeatCount = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BONUS_FEAT_COUNT);
   FeatCount++;
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS, FeatID, SUBRACE_BONUS_FEAT_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS, Remove, SUBRACE_BONUS_FEAT_REMOVE_FLAG);
   SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BONUS_FEAT_COUNT, FeatCount);
}

void ChangePortrait(string subraceName, string MalePortrait, string FemalePortrait, int Level = 1)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   SetLocalString(oStorer, SubraceTag + "_" + IntToString(Level)+ "_" + SUBRACE_PORTRAIT_MALE, MalePortrait);
   SetLocalString(oStorer, SubraceTag + "_" + IntToString(Level)+ "_" + SUBRACE_PORTRAIT_FEMALE , FemalePortrait);
}

void ChangeSoundSet(string subraceName, int MaleSoundSet, int FemaleSoundSet, int Level = 1)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(Level)+ "_" + SUBRACE_SOUNDSET_FLAGS, MaleSoundSet, SUBRACE_SOUNDSET_MALE_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(Level)+ "_" + SUBRACE_SOUNDSET_FLAGS, FemaleSoundSet, SUBRACE_SOUNDSET_FEMALE_FLAG);
}

void ModifySubraceSkill(string subraceName, int SkillID, int iModifier, int Level = 1, int Set = FALSE)
{
   subraceName = GetStringLowerCase(subraceName);
   string SubraceTag = SUBRACE_TAG + "_" + subraceName;
   SubraceTag = SubraceTag + "_" + IntToString(Level);
   int SkillCount = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BONUS_SKILL_COUNT);
   SkillCount++;
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SkillID, SUBRACE_BONUS_SKILL_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, Set, SUBRACE_BONUS_SKILL_REMOVE_FLAG);
   SetLocalGroupFlagValue(oStorer, SubraceTag + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, iModifier, SUBRACE_BONUS_SKILL_MODIFIER_FLAG);
   SetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_BONUS_SKILL_COUNT, SkillCount);
}



























void DelayBoot(object oPC)
{
   if(GetLocalInt(oPC, "SUBRACE_NEEDS_TO_RELOG"))
   {
      BootPC(oPC);
   }
}



void SetIsInDarkness(object oPC, int Flag)
{
  string subrace = GetStringLowerCase(GetSubRace(oPC));
  if(subrace == "")
  { return; }
  string SubraceTag = SUBRACE_TAG + "_" + subrace;
  int IsLightSens = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
  int DmgTakenL = GetLocalInt(oPC, SubraceTag + "_" + DAMAGE_AMOUNT_IN_LIGHT);
  if(IsLightSens || DmgTakenL > 0)
  {
     SetLocalInt(oPC, SUBRACE_IN_SPELL_DARKNESS, Flag);
  }
}

int Subrace_GetIsInDarkness(object oPC)
{
   return GetLocalInt(oPC, SUBRACE_IN_SPELL_DARKNESS);
}

void ApplyLightSensitivity(object oPC)
{
  if(SPELL_DARKNESS_STOPS_LIGHT_SENSITIVITY && Subrace_GetIsInDarkness(oPC))
  {
      return;
  }
  if(!GetLocalInt(oPC, "STRUCK_BLIND"))
  {
     if(APPLY_LIGHT_BLINDNESS)
     {
       if(FortitudeSave(oPC, LIGHT_SENSITIVE_SAVING_THROW_DC) == 0)
       {
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, RoundsToSeconds(LIGHT_STRUCK_BLIND_FOR_ROUNDS));
       }
     SetLocalInt(oPC, "STRUCK_BLIND", TRUE);
     DelayCommand(RoundsToSeconds(LIGHT_BLINDNESS_STRIKES_EVERY_ROUND), SetLocalInt(oPC, "STRUCK_BLIND", FALSE));
    }
  }
  if(APPLY_AB_AND_SAVING_THROW_DECREASES_IN_LIGHT && !GetLocalInt(oPC, "STRUCK_LIGHT_DEC"))
  {
      effect ABDecrease =  EffectAttackDecrease(LIGHT_AB_DECREASE, ATTACK_BONUS_ONHAND);
      effect ABDecrease1 =  EffectAttackDecrease(LIGHT_AB_DECREASE, ATTACK_BONUS_OFFHAND);
      effect SaveDecrease = EffectSavingThrowDecrease(SAVING_THROW_ALL, LIGHT_SAVE_DECREASE, SAVING_THROW_TYPE_ALL);
      effect Link = EffectLinkEffects(ABDecrease, ABDecrease1);
      Link = SupernaturalEffect(EffectLinkEffects(SaveDecrease, Link));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, Link, oPC, RoundsToSeconds(LIGHT_CAUSES_AB_AND_SAVES_DECREASE_FOR_ROUNDS + 1));
      SetLocalInt(oPC, "STRUCK_LIGHT_DEC", TRUE);
      DelayCommand(RoundsToSeconds(LIGHT_CAUSES_AB_AND_SAVES_DECREASE_FOR_ROUNDS), SetLocalInt(oPC, "STRUCK_LIGHT_DEC", FALSE));
   }
}

int GetIsPCLightSensitive(object oPC)
{
   string SubraceTag = SUBRACE_TAG + "_" + GetStringLowerCase(GetSubRace(oPC));
   return GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
}

void ApplyUndergroundSensitivity(object oPC)
{
  if(!GetLocalInt(oPC, "STRUCK_BLIND_UND"))
  {
       if(FortitudeSave(oPC, DARK_SENSITIVE_SAVING_THROW_DC) == 0)
       {
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, DARK_STRUCK_BLIND_FOR_ROUNDS*6.0);
       }
       SetLocalInt(oPC, "STRUCK_BLIND_UND", TRUE);
       DelayCommand(RoundsToSeconds(DARK_BLINDNESS_STRIKES_EVERY_ROUND), SetLocalInt(oPC, "STRUCK_BLIND_UND", FALSE));
  }
}

void SubraceSpontaneouslyCombust(object oPC)
{
   if(ReflexSave(oPC, SUBRACE_SPONTANEOUSLY_COMBUST_DC) != 0)
   {  return; }
   effect FireDmg  = EffectDamage(d8(), DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);
   effect VisEffect = EffectVisualEffect(VFX_IMP_FLAME_S);
   effect iLink = EffectLinkEffects(FireDmg, VisEffect);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, iLink, oPC, 6.0);

}
void ApplyDamageWhileInLight(object oPC, int DmgTaken)
{
  if(SPELL_DARKNESS_STOPS_LIGHT_SENSITIVITY && Subrace_GetIsInDarkness(oPC))
  {
      return;
  }
  if(!GetLocalInt(oPC, "SB_LGHT_DMGED"))
  {
    SetLocalInt(oPC, "SB_LGHT_DMGED", TRUE);
    effect LightDamage;
    if(DmgTaken > 0)
    {
        LightDamage = EffectDamage(DmgTaken, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY);
    }
    else if(DmgTaken < 0)
    {
       DmgTaken = abs(DmgTaken);
       LightDamage = EffectRegenerate(DmgTaken, 1.0);
    }
    if(SUBRACE_SPONTANEOUS_COMBUSTION_WHILE_IN_LIGHT)
    {
        if(d100() <= SUBRACE_SPONTANEOUS_COMBUSTION_PERCENTAGE)
        {
          int i = 0;
          //Combust visual effect.
          effect eDur = EffectVisualEffect(498);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPC, RoundsToSeconds(LIGHT_DAMAGES_EVERY_ROUNDS));

          while(i != LIGHT_DAMAGES_EVERY_ROUNDS)
          {
             DelayCommand(RoundsToSeconds(i), SubraceSpontaneouslyCombust(oPC));
             i++;
          }
        }
    }
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, LightDamage, oPC, 1.0);
    DelayCommand(RoundsToSeconds(LIGHT_DAMAGES_EVERY_ROUNDS), SetLocalInt(oPC,"SB_LGHT_DMGED", FALSE));
  }
}

void ApplyDamageWhileInDark(object oPC, int DmgTaken)
{
  if(!GetLocalInt(oPC, "SB_DARK_DMGED"))
  {
   SetLocalInt(oPC, "SB_DARK_DMGED", TRUE);
   effect DarkDamage;
   if(DmgTaken > 0)
   {
       DarkDamage = EffectDamage(DmgTaken, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_ENERGY);
   }
   else if(DmgTaken < 0)
   {
       DmgTaken = abs(DmgTaken);
       DarkDamage = EffectRegenerate(DmgTaken, 1.0);
   }
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, DarkDamage, oPC, 1.0);
   DelayCommand(RoundsToSeconds(DARKNESS_DAMAGES_EVERY_ROUNDS), SetLocalInt(oPC,"SB_DARK_DMGED", FALSE));
  }
}
int CheckIfPCMeetsBaseRaceCriteria(object oPC, string SubraceTag)
{
    int PCRace = GetRacialType(oPC);
    int iResult = FALSE;
    switch(PCRace)
    {
      case RACIAL_TYPE_DWARF:
          {
             if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG1, SUBRACE_BASE_RACE_FLAGS))
             {
                iResult = TRUE;
             }
              break;
           }
      case RACIAL_TYPE_ELF:
          {
             if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG2, SUBRACE_BASE_RACE_FLAGS))
             {
                iResult = TRUE;
             }
              break;
           }
      case RACIAL_TYPE_GNOME:
          {
             if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG3, SUBRACE_BASE_RACE_FLAGS))
             {
                iResult = TRUE;
             }
                break;
           }
      case RACIAL_TYPE_HALFELF:
          {
             if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG4, SUBRACE_BASE_RACE_FLAGS))
             {
                iResult = TRUE;
             }
             break;
          }
      case RACIAL_TYPE_HALFLING:
          {
             if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG5, SUBRACE_BASE_RACE_FLAGS))
             {
                iResult = TRUE;
             }
                break;
           }
      case RACIAL_TYPE_HALFORC:
          {
             if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG6, SUBRACE_BASE_RACE_FLAGS))
             {
                iResult = TRUE;
             }
              break;
           }
      case RACIAL_TYPE_HUMAN:
          {
             if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG7, SUBRACE_BASE_RACE_FLAGS))
             {
                iResult = TRUE;
             }
             break;
          }
      case RACIAL_TYPE_ALL:
         {
             if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, ALLFLAGS, SUBRACE_BASE_RACE_FLAGS))
             {
                iResult = TRUE;
             }
             break;
          }
      default:
         {
            if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, NOFLAGS, SUBRACE_BASE_RACE_FLAGS))
             {
                iResult = TRUE;
             }
             break;
         }

  }
  return iResult;
  //return CheckPCRaceFitsAdditionalBaseRace(oPC, SubraceTag, NumberOfBaseRace);
}

int CheckIfPCMeetsClassCriteria(object oPC, string SubraceTag)
{
   int check = FALSE;
   int PCClass = GetClassByPosition(1, oPC);

   int canBeBarbarian = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG2);
   int canBeBard = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG3);
   int canBeCleric = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG4);
   int canBeDruid = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG5);
   int canBeFighter = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG6);
   int canBeMonk =   GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG7);
   int canBePaladin = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG8);
   int canBeRanger = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG9);
   int canBeRogue =  GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG10);
   int canBeSorcerer = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG11);
   int canBeWizard =   GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG12);

    if((PCClass == CLASS_TYPE_BARBARIAN && canBeBarbarian) || (PCClass == CLASS_TYPE_BARD && canBeBard) || (PCClass == CLASS_TYPE_CLERIC && canBeCleric) || (PCClass == CLASS_TYPE_DRUID && canBeDruid) || (PCClass == CLASS_TYPE_FIGHTER && canBeFighter) || (PCClass == CLASS_TYPE_MONK && canBeMonk) || (PCClass == CLASS_TYPE_PALADIN && canBePaladin) || (PCClass == CLASS_TYPE_RANGER && canBeRanger) || (PCClass == CLASS_TYPE_ROGUE && canBeRogue) || (PCClass == CLASS_TYPE_SORCERER && canBeSorcerer) || (PCClass == CLASS_TYPE_WIZARD && canBeWizard))
    { check = TRUE; }
    return check;
}

int CheckIfPCMeetsPrestigiousClassCriteria(object oPC, string SubraceTag)
{

   int MinLevel = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION_MINIMUM_LEVELS);

   //Flags
   SetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG1, TRUE);

   int CanBe_AA = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG2);

   int CanBe_ASS = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG3);

   int CanBe_BG = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG4);

   int CanBe_COT = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG5);

   int CanBe_RDD = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG6);

   int CanBe_DD = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG7);

   int CanBe_PM = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG8);

   int CanBe_SD = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG9);

   int CanBe_SHF = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG10);

   int CanBe_WM = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG11);

   int CanBe_Harper =  GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION, FLAG12);

   int PClass1 = GetClassByPosition(2, oPC);
   int PClass2 = GetClassByPosition(3, oPC);

   int PClass1Level = GetLevelByClass(PClass1, oPC);
   int PClass2Level = GetLevelByClass(PClass2, oPC);

   int Class1Check = FALSE;
   int Class2Check = FALSE;
   switch(PClass1)
   {
      case CLASS_TYPE_ARCANE_ARCHER:
                                     if(CanBe_AA)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_ASSASSIN:
                                    if(CanBe_ASS)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_BLACKGUARD:
                                    if(CanBe_BG)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_DIVINE_CHAMPION:
                                    if(CanBe_COT)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_DRAGON_DISCIPLE:
                                     if(CanBe_RDD)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_DWARVEN_DEFENDER:
                                     if(CanBe_DD)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_HARPER:
                                     if(CanBe_Harper)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_PALE_MASTER:
                                     if(CanBe_PM)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_SHADOWDANCER:
                                     if(CanBe_SD)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_SHIFTER:
                                     if(CanBe_SHF)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_WEAPON_MASTER:
                                     if(CanBe_WM)
                                     {
                                        Class1Check = TRUE;
                                     }
                                     break;
      default: break;

   }

   switch(PClass2)
   {
      case CLASS_TYPE_ARCANE_ARCHER:
                                     if(CanBe_AA)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_ASSASSIN:
                                    if(CanBe_ASS)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_BLACKGUARD:
                                    if(CanBe_BG)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_DIVINE_CHAMPION:
                                    if(CanBe_COT)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_DRAGON_DISCIPLE:
                                     if(CanBe_RDD)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_DWARVEN_DEFENDER:
                                     if(CanBe_DD)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_HARPER:
                                     if(CanBe_Harper)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_PALE_MASTER:
                                     if(CanBe_PM)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_SHADOWDANCER:
                                     if(CanBe_SD)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_SHIFTER:
                                     if(CanBe_SHF)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      case CLASS_TYPE_WEAPON_MASTER:
                                     if(CanBe_WM)
                                     {
                                        Class2Check = TRUE;
                                     }
                                     break;
      default: break;

   }

   if(!Class1Check && !Class2Check)
   {  return FALSE; }

   if(Class1Check && Class2Check)
   {
      if(PClass1Level + PClass2Level >= MinLevel)
      {
          return TRUE;
      }
      else
      {
         return FALSE;
      }
   }
   if(Class1Check)
   {
      if(PClass1Level >= MinLevel)
      {
          return TRUE;
      }
      else
      {
         return FALSE;
      }

   }
   if(Class2Check)
   {
      if(PClass2Level >= MinLevel)
      {
          return TRUE;
      }
      else
      {
         return FALSE;
      }

   }

   return FALSE;
}


int CheckIfPCMeetsAlignmentCriteria(object oPC, string SubraceTag)
{
    int check1 = FALSE;
    int check2 = FALSE;

    int PCAlign1 = GetAlignmentGoodEvil(oPC);
    int PCAlign2 = GetAlignmentLawChaos(oPC);

    int align1 = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG2);
    int align2 = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG3);
    int align3 = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG4);
    int align4 = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG5);
    int align5 = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG6);
    int align6 = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG7);
    if((PCAlign1 == ALIGNMENT_GOOD && align1) || (PCAlign1 == ALIGNMENT_NEUTRAL && align2) || (PCAlign1 == ALIGNMENT_EVIL && align3))
    {check1 = TRUE;}
    if((PCAlign2 == ALIGNMENT_LAWFUL && align4) || (PCAlign2 == ALIGNMENT_NEUTRAL && align5) || (PCAlign2 == ALIGNMENT_CHAOTIC && align6))
    {check2 = TRUE;}

    if(check1 && check2)
    { return TRUE; }
    else
    { return FALSE;}
}




int CheckIfPCMeetsAnySubraceCriteria(object oPC)
{

   string subraceName = GetStringLowerCase(GetSubRace(oPC));
   int check = FALSE;

   string SubraceTag = SUBRACE_TAG + "_" + subraceName;

   int CheckForSubrace = GetLocalInt(oStorer, SubraceTag);

   if(CheckForSubrace)
   {
      int IsPrestigious = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_PRESTIGIOUS_SUBRACE, SUBRACE_BASE_INFORMATION_FLAGS);
      if(IsPrestigious && GetPlayerLevel(oPC) == 1)
      {
         SHA_SendSubraceMessageToPC(oPC, MESSAGE_CANNOT_BE_PART_OF_PRESTIGIOUS_SUBRACE, TRUE);
         check = FALSE;
         SetSubRace(oPC, "");
         return check;
      }
      if(IsPrestigious && GetPlayerLevel(oPC) > 1)
      {
          int checkPClass = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_PRESTIGIOUS_CLASS_RESTRICTION);
          if(checkPClass != 0)
          {
             if(!CheckIfPCMeetsPrestigiousClassCriteria(oPC, SubraceTag))
             {
                 SHA_SendSubraceMessageToPC(oPC, MESSAGE_FAILED_TO_MEET_PRESTIGIOUS_CLASS_RESTRICTION, TRUE);
                 SetSubRace(oPC, "");
                 return FALSE;
             }
          }

      }
      int checkRace = CheckIfPCMeetsBaseRaceCriteria(oPC, SubraceTag);
      if(checkRace)
      {
             int CheckForAlignment = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_ALIGNMENT_RESTRICTION, FLAG1);
             if(CheckForAlignment)
             {
                int checkAlign = CheckIfPCMeetsAlignmentCriteria(oPC, SubraceTag);
                if(checkAlign)
                {
                   int CheckForClass = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG1);
                   if(CheckForClass)
                   {
                      int checkClass = CheckIfPCMeetsClassCriteria(oPC,SubraceTag);
                      if(checkClass)
                      {
                          SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CRITERIA_MET, TRUE);
                          check = TRUE;
                      }
                      else
                      {
                          SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CRITERIA_CLASS_FAILED, TRUE);
                          check = FALSE;
                          SetSubRace(oPC, "");
                      }
                   }
                   else
                   {
                       //NO NEED FOR CLASS CHECKING
                       SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CRITERIA_MET, TRUE);
                       check = TRUE;
                   }
                }
                else
                {
                   //FAILED ALIGNMENT CRITERIA
                    SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CRITERIA_ALIGNMENT_FAILED, TRUE);
                    check = FALSE;
                    SetSubRace(oPC, "");
                }
             }
             else
             {
                 //NO NEED FOR ALIGNMENT CHECKING
                 int CheckForClass = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_CLASS_RESTRICTION, FLAG1);
                 if(CheckForClass)
                 {
                      int checkClass = CheckIfPCMeetsClassCriteria(oPC,SubraceTag);
                      if(checkClass)
                      {
                        SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CRITERIA_MET, TRUE);
                        check = TRUE;
                      }
                      else
                      {
                         SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CRITERIA_CLASS_FAILED, TRUE);
                         check = FALSE;
                         SetSubRace(oPC, "");
                      }

                 }
                 else
                 {
                     //NO NEED FOR CLASS CHECKING
                     SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CRITERIA_MET, TRUE);
                     check = TRUE;
                 }
             }
      }
      else
      {
        SHA_SendSubraceMessageToPC(oPC, MESSGAE_SUBRACE_CRITERIA_BASE_RACE_FAILED, TRUE);
        check = FALSE;
        SetSubRace(oPC, "");
        //FAILED BASE RACE
      }
   }
   else
   {
        SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_UNRECOGNISED + GetSubRace(oPC), TRUE);
        check = SUBRACE_UNRECOGNISED;
       //FAILED TO FIND ANY SUCH SUBRACE
   }
   return check;
}

string GetTemporarySubraceSkin(object oPC, string SubraceTag, int iTime)
{
   int Level = GetPlayerLevel(oPC);
   string SkinResRef;
   while(Level > 0)
   {
      string resref = GetLocalString(oPC, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(iTime));
      if(resref != "")
      {
        SkinResRef = resref;
        break;
      }
      Level--;
   }
   return SkinResRef;
}


void EquipTemporarySubraceSkin(string subraceTag, object oPC, int iTime)
{
   string oSkin = GetTemporarySubraceSkin(oPC, subraceTag, iTime);
   if(oSkin == "")
   {
       oSkin = GetTemporarySubraceSkin(oPC, subraceTag, TIME_BOTH);
   }
   object ExistingSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
   string ResrefExistingSkin = GetStringLowerCase(GetResRef(ExistingSkin));
   if(ResrefExistingSkin != oSkin)
   {
       object NewSkin = CreateItemOnObject(oSkin, oPC);
       if(GetIsObjectValid(ExistingSkin))
       {
           SetPlotFlag(ExistingSkin, FALSE);
           DestroyObject(ExistingSkin, 0.2);
       }
       SetIdentified(NewSkin, TRUE);
       DelayCommand(1.0, AssignCommand(oPC, SHA_SubraceForceEquipItem(NewSkin, INVENTORY_SLOT_CARMOUR)));
   }
}

string GetTemporarySubraceClaw(object oPC, string subraceTag, string Claw, int iTime)
{
   int Level = GetPlayerLevel(oPC);
   string ClawResRef = "";
   while(Level > 0)
   {
      string resref = GetLocalString(oPC, subraceTag + "_" + Claw + "_" + IntToString(Level) + "_" + IntToString(iTime));
      if(resref != "")
      {
        ClawResRef = resref;
        break;
      }
      Level--;
   }
   return ClawResRef;
}


void EquipTemporarySubraceClaw(string subraceTag, object oPC, int iTime)
{
   string sLeftClaw = GetTemporarySubraceClaw(oPC, subraceTag, SUBRACE_LEFT_CLAW, iTime);
   string sRightClaw = GetTemporarySubraceClaw(oPC, subraceTag, SUBRACE_RIGHT_CLAW, iTime);

   if(sLeftClaw == "")
   {
       sLeftClaw = GetTemporarySubraceClaw(oPC, subraceTag, SUBRACE_LEFT_CLAW, TIME_BOTH);
   }
   if(sRightClaw == "")
   {
       sRightClaw = GetTemporarySubraceClaw(oPC, subraceTag, SUBRACE_RIGHT_CLAW, TIME_BOTH);
   }
   object ExistingLeftClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
   object ExistingRightClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
   string ResrefExistingLClaw = GetStringLowerCase(GetResRef(ExistingLeftClaw));
   string ResrefExistingRClaw = GetStringLowerCase(GetResRef(ExistingRightClaw));
   if((ResrefExistingRClaw != sRightClaw) || (ResrefExistingLClaw != sLeftClaw))
   {
         SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CLAWS_WAIT_FOR_CLAWS_EQUIPPING, FALSE);
         if(!GetHasFeat(FEAT_WEAPON_PROFICIENCY_CREATURE, oPC))
         {
            SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CLAWS_MISSING_CREATURE_WEAPON_PROFICIENCY, TRUE);
            return;
         }
         DelayCommand(9.0, SHA_SendSubraceMessageToPC(oPC,MESSAGE_SUBRACE_CLAWS_SUCCESSFULLY_EQUIPPED, FALSE));
    }
    if(ResrefExistingRClaw != sRightClaw)
    {
           object NewRClaw = CreateItemOnObject(sRightClaw, oPC);
           if(sRightClaw == "none" || GetIsObjectValid(ExistingRightClaw))
           {
               SetPlotFlag(ExistingRightClaw, FALSE);
               DestroyObject(ExistingRightClaw, 0.2);
           }
           SetIdentified(NewRClaw, TRUE);
           DelayCommand(1.0, AssignCommand(oPC, SHA_SubraceForceEquipItem(NewRClaw, INVENTORY_SLOT_CWEAPON_R)));
     }
     if(ResrefExistingLClaw != sLeftClaw)
     {
           object NewLClaw = CreateItemOnObject(sLeftClaw, oPC);
           if(sLeftClaw == "none"  || GetIsObjectValid(ExistingLeftClaw))
           {
               SetPlotFlag(ExistingLeftClaw, FALSE);
               DestroyObject(ExistingLeftClaw, 0.3);
           }
           SetIdentified(NewLClaw, TRUE);
           DelayCommand(5.0, AssignCommand(oPC, SHA_SubraceForceEquipItem(NewLClaw, INVENTORY_SLOT_CWEAPON_L)));
     }
}

void SearchAndDestroySkinsAndClaws(object oPC)
{
   object oItem = GetFirstItemInInventory(oPC);
   while(GetIsObjectValid(oItem))
   {
       int iType = GetBaseItemType(oItem);
       if(iType == BASE_ITEM_CREATUREITEM || iType == BASE_ITEM_CPIERCWEAPON || iType == BASE_ITEM_CSLASHWEAPON || iType == BASE_ITEM_CSLSHPRCWEAP)
       {
          SetPlotFlag(oItem, FALSE);
          DestroyObject(oItem, 0.1);
       }
       oItem = GetNextItemInInventory(oPC);
   }


}

void GiveSubraceUniqueItem(string SubraceTag, object oPC)
{
    int SubraceUniqueItemCount = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_UNIQUEITEM_COUNT);
    int i = 0;
    while(i <= SubraceUniqueItemCount)
    {
       i++;
       string resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_UNIQUEITEM + "_" + IntToString(i));
       if(resref != "")
       {
           string sLevel = GetStringRight(resref, 2);
           if(GetStringLeft(sLevel, 1) == "_")
           {
              sLevel = GetStringRight(sLevel, 1);
           }
           int iLevel = StringToInt(sLevel);
           resref = GetStringLeft(resref, GetStringLength(resref) - 2);
           if(iLevel <= GetPlayerLevel(oPC))
           {
               object oItem = GetFirstItemInInventory(oPC);
               int HasUniqueItem = FALSE;
               while(GetIsObjectValid(oItem))
               {
                   if(GetResRef(oItem) == resref)
                   {
                      HasUniqueItem = TRUE;
                      break;
                   }
                  oItem = GetNextItemInInventory(oPC);
               }
               if(!HasUniqueItem)
               {
                  object oItem = CreateItemOnObject(resref, oPC, 1);
                  DelayCommand(1.0, SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_ACQUIRED_UNIQUE_ITEM1 + GetName(oItem) + MESSAGE_SUBRACE_ACQUIRED_UNIQUE_ITEM2, FALSE));
                  SetIdentified(oItem, TRUE);
                  SetPlotFlag(oItem, TRUE);
               }
           }
      }
    }
}

void CheckAndGiveSubraceItems(object oPC)
{
   string subrace = GetSubRace(oPC);
   string SubraceTag = SUBRACE_TAG + "_" + GetStringLowerCase(subrace);
   GiveSubraceUniqueItem(SubraceTag, oPC);
}
int SHA_GetDefaultAppearanceType(object oPC)
{
   int iRace = GetRacialType(oPC);
   int DefaultAppearance;
   switch(iRace)
   {
      case RACIAL_TYPE_DWARF: DefaultAppearance = APPEARANCE_TYPE_DWARF; break;
      case RACIAL_TYPE_ELF: DefaultAppearance = APPEARANCE_TYPE_ELF; break;
      case RACIAL_TYPE_GNOME: DefaultAppearance = APPEARANCE_TYPE_GNOME;  break;
      case RACIAL_TYPE_HALFELF: DefaultAppearance = APPEARANCE_TYPE_HALF_ELF;  break;
      case RACIAL_TYPE_HALFLING: DefaultAppearance = APPEARANCE_TYPE_HALFLING; break;
      case RACIAL_TYPE_HALFORC: DefaultAppearance = APPEARANCE_TYPE_HALF_ORC;  break;
      case RACIAL_TYPE_HUMAN: DefaultAppearance = APPEARANCE_TYPE_HUMAN;  break;
      default: DefaultAppearance = APPEARANCE_TYPE_HUMAN;  break;
   }
   return DefaultAppearance;
}

int Subrace_GetFavouredClass(object oPC)
{
   int iClass = -1;

   if(GetLocalInt(oPC, SUBRACE_FAVORED_CLASS) != 0)
   {
      iClass = GetLocalInt(oPC, SUBRACE_FAVORED_CLASS) - 1;
   }
   return iClass;
}

int GetRacialFavoredClass(int Race)
{
    int Class = CLASS_TYPE_NONE;
    switch(Race)
    {
       case RACIAL_TYPE_DWARF: Class = CLASS_TYPE_FIGHTER; break;
       case RACIAL_TYPE_HUMAN: Class = CLASS_TYPE_ANY; break;
       case RACIAL_TYPE_ELF: Class = CLASS_TYPE_WIZARD; break;
       case RACIAL_TYPE_GNOME: Class = CLASS_TYPE_WIZARD; break;
       case RACIAL_TYPE_HALFELF: Class = CLASS_TYPE_ANY; break;
       case RACIAL_TYPE_HALFORC: Class = CLASS_TYPE_BARBARIAN; break;
       case RACIAL_TYPE_HALFLING: Class = CLASS_TYPE_ROGUE; break;
   }
   return Class;
}

int GetFavoredClassExceedsGap(int Race1Favored, int Race2Favored, int Class1, int Class2, int Class3, int Class13Gap, int Class23Gap, int Class12Gap)
{
   //Has PC got Race 1 Favored class?
   int iR1Class1Favored = FALSE;
   int iR1Class2Favored = FALSE;
   int iR1Class3Favored = FALSE;

    //Has PC got  Race 2 Favored class?
   int iR2Class1Favored = FALSE;
   int iR2Class2Favored = FALSE;
   int iR2Class3Favored = FALSE;

   if(Race1Favored == Class1)
   {
      iR1Class1Favored = TRUE;
   }
   if(Race1Favored == Class2 && Class2 != CLASS_TYPE_INVALID)
   {
      iR1Class2Favored = TRUE;
   }
   if(Race1Favored == Class3 && Class3 != CLASS_TYPE_INVALID)
   {
      iR1Class3Favored = TRUE;
   }

   if(Race2Favored == Class1)
   {
      iR2Class1Favored = TRUE;
   }
   if(Race2Favored == Class2 && Class2 != CLASS_TYPE_INVALID)
   {
      iR2Class2Favored = TRUE;
   }
   if(Race2Favored == Class3 && Class3 != CLASS_TYPE_INVALID)
   {
      iR2Class3Favored = TRUE;
   }

   int Exceed12 = FALSE;
   int Exceed13 = FALSE;
   int Exceed23 = FALSE;

   int iResult12 = FALSE;
   int iResult13 = FALSE;
   int iResult23 = FALSE;

   if(abs(Class12Gap) >=2)
   {
      Exceed12 = TRUE;
   }
   else if(abs(Class13Gap) >=2)
   {
      Exceed13 = TRUE;
   }
   else if(abs(Class23Gap) >=2)
   {
      Exceed23 = TRUE;
   }

   if(Exceed12)
   {
      if(iR1Class1Favored || iR1Class2Favored)
      {
         iResult12 = TRUE;
         if((iR2Class1Favored && Class3 != CLASS_TYPE_INVALID) || (iR2Class2Favored && Class3 != CLASS_TYPE_INVALID))
         {
           iResult12 = FALSE;
         }
      }
   }
   if(Exceed13)
   {
      if(iR1Class1Favored || iR1Class3Favored)
      {
         iResult13 = TRUE;
         if(iR2Class1Favored ||iR2Class3Favored)
         {
           iResult13 = FALSE;
         }
      }
   }
   if(Exceed23)
   {
      if(iR1Class2Favored || iR1Class3Favored)
      {
         iResult23 = TRUE;
         if(iR2Class2Favored ||iR2Class3Favored)
         {
           iResult23 = FALSE;
         }
      }
   }

   if(iResult12 || iResult13 || iResult23)
   {
      return TRUE;
   }
   else
   {
      return FALSE;
   }
}

int XPPenaltyOrBoostForSubrace(object oPC, int FClass)
{
   int iRace = GetRacialType(oPC);
   int iRFavored = GetRacialFavoredClass(iRace);

   int iSFavored = FClass;
   if(iSFavored == iRFavored)
   {
      return SUBRACE_XP_UNCHANGED;
   }

   int Class1 = GetClassByPosition(1, oPC);
   int Class2 = GetClassByPosition(2, oPC);
   int Class3 = GetClassByPosition(3, oPC);

   int Class1Level = GetLevelByClass(Class1, oPC);
   int Class2Level = GetLevelByClass(Class2, oPC);
   int Class3Level = GetLevelByClass(Class3, oPC);

   if(iRFavored == CLASS_TYPE_ANY)
   {
       int Max1 = Max(Class1Level, Class2Level);
       int Max2 = Max(Max1, Class3Level);

       if(Max2 == Class1Level)
       {
         iRFavored = Class1;
       }
       else if(Max2 == Class2Level)
       {
          iRFavored = Class2;
       }
       else if(Max2 == Class3Level)
       {
         iRFavored = Class3;
       }
   }

   if(iSFavored == CLASS_TYPE_ANY)
   {
       int Max1 = Max(Class1Level, Class2Level);
       int Max2 = Max(Max1, Class3Level);

       if(Max2 == Class1Level)
       {
         iSFavored = Class1;
       }
       else if(Max2 == Class2Level)
       {
          iSFavored = Class2;
       }
       else if(Max2 == Class3Level)
       {
         iSFavored = Class3;
       }
   }

   int Class12Gap = Class1Level - Class2Level;
   int Class13Gap = Class1Level - Class3Level;
   int Class23Gap = Class2Level - Class3Level;

   if(Class2Level == 0)
   {
      Class12Gap = 0;
      Class23Gap = 0;
   }
   if(Class3Level == 0)
   {
      Class13Gap = 0;
   }
   int SubraceFClassExcGap = FALSE;
   int RacialFClassExcGap = FALSE;

   if(SUBRACE_IGNORE_BASE_RACE_FAVORED_CLASS)
   {
       RacialFClassExcGap = GetFavoredClassExceedsGap(iRFavored, iSFavored, Class1, Class2, Class3, Class13Gap, Class23Gap, Class12Gap);
   }

   SubraceFClassExcGap = GetFavoredClassExceedsGap(iSFavored, iRFavored, Class1, Class2, Class3, Class13Gap, Class23Gap, Class12Gap);
   //Racial Favored Class Exceeds the Multiclass Level gap, and Subrace Favored class does not
   //So give a decrease in XP to counter NWN engine XP distribution.
   if(RacialFClassExcGap && !SubraceFClassExcGap)
   {
      return SUBRACE_XP_DECREASE;
   }
   //Subrace Favored Class Exceeds the Multiclass Level gap, and Racial Favored class does not
   //So give a boost in XP to override the NWN engine XP distribution.
   else if(!RacialFClassExcGap && SubraceFClassExcGap)
   {
      return SUBRACE_XP_BOOST;
   }
   //Both exceed the Multiclass Level gap or do not.
   //So since the effects of both exceeding cancel each other out, return normal XP.
   return SUBRACE_XP_UNCHANGED;
}

float GetSubraceXPModifier(object oPC)
{
  int FClass = Subrace_GetFavouredClass(oPC);
  float iMod = 1.0;
  if(FClass != -1)
  {
      int XPMod = XPPenaltyOrBoostForSubrace(oPC, FClass);

      if(XPMod == SUBRACE_XP_BOOST)
      {
          iMod = 1.25;
      }
      else if(XPMod == SUBRACE_XP_DECREASE)
      {
          iMod = 0.8;
      }
      else if(XPMod == SUBRACE_XP_UNCHANGED)
      {  }
  }
  return iMod;

}

int GetECL(object oPC)
{
   string SubraceTag = SUBRACE_TAG + "_" + GetStringLowerCase(GetSubRace(oPC));
   return GetLocalGroupFlagValue(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_ECL);
}

int Subrace_GetIsUndead(object oTarget)
{
  if(!GetIsPC(oTarget))
  {
     return FALSE;
  }
  string subraceName = GetStringLowerCase(GetSubRace(oTarget));

  if(subraceName == "")
  { return FALSE; }
  string SubraceTag = SUBRACE_TAG + "_" + subraceName;
  int IsUndead = GetLocalGroupFlag(oTarget, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDEAD, SUBRACE_BASE_INFORMATION_FLAGS);
  return IsUndead;

}
void ApplyUniqueSubraceEffect(object oPC, string SubraceTag, int iEffect)
{
     if(iEffect == 0)
     { return; }
     int Value1 = GetLocalInt(oPC, SubraceTag + "_" + SUBRACE_EFFECT_VALUE_1);
     int Value2 = GetLocalInt(oPC, SubraceTag + "_" + SUBRACE_EFFECT_VALUE_2);
     int DurationType = GetLocalInt(oPC, SubraceTag + "_" + SUBRACE_EFFECT_DURATION_TYPE);
     float fDuration = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_EFFECT_DURATION);

     effect eEffect = SHA_GetEffectFromID(iEffect, Value1, Value2);
     effect eEffectApp = SupernaturalEffect(eEffect);
     ApplyEffectToObject(DurationType, eEffectApp, oPC, fDuration);
}
void ApplySubraceEffect(object oPC, string SubraceTag, int TimeOfDay)
{
   int EffectCount = GetLocalInt(oPC, SubraceTag + "_" + SUBRACE_EFFECT_COUNT);
   if(EffectCount == 0)
   {
       return;
   }

   ClearSubraceEffects(oPC);
   int i = 0;
   while(i != EffectCount)
   {
     i++;
     string SubraceTag1 = SubraceTag + IntToString(i);
     int Effect = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT);
     int EffectTimeOfDay = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_APPLY_TIME);
     if(EffectTimeOfDay == TIME_BOTH || EffectTimeOfDay == TimeOfDay)
     {
        ApplyUniqueSubraceEffect(oPC, SubraceTag1, Effect);
     }
  }
  SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_EFFECTS_APPLIED, FALSE);
}



void LoadSubraceInfoOnPC(object oPC, string subraceName)
{
    if(GetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC))
    {
        ReapplySubraceAbilities(oPC);
        return;
    }
    if(subraceName == "")
    { return; }
    string SubraceTag = SUBRACE_TAG + "_" + subraceName;


    //Oh oh, someone has removed the subrace! >.<
    if(!GetLocalInt(oStorer, SubraceTag))
    {
        SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_IS_MISSING_FROM_SERVER, TRUE);
        return;
    }
    SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_LOADING_DATA1+ CapitalizeString(subraceName) + MESSAGE_SUBRACE_LOADING_DATA2, FALSE);

    int Gender = GetGender(oPC);

    int Count =  GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_FACTION_COUNT);
    if(Count != 0)
    {
        SetLocalInt(oPC, SubraceTag + "_" + SUBRACE_FACTION_COUNT, Count);
        while(Count != 0)
        {
            string  FactionCreatureTag = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_FACTION_CREATURE + "_" + IntToString(Count));
            int Reputation = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_FACTION_REPUTATION + "_" + IntToString(Count));
            SetLocalString(oPC, SubraceTag + "_" + SUBRACE_FACTION_CREATURE + "_" + IntToString(Count), FactionCreatureTag);
            SetLocalInt(oPC, SubraceTag + "_" + SUBRACE_FACTION_REPUTATION + "_" + IntToString(Count), Reputation);
            Count--;
        }
    }
    //Load all skin resrefs
    int Level = 1;
    while(Level <= MAXIMUM_PLAYER_LEVEL)
    {
      string resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(TIME_BOTH));
      if(resref != "")
      {
        SetLocalString(oPC, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(TIME_BOTH), resref);
      }
      //and the temporary skins
      resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(TIME_DAY));
      if(resref != "")
      {
        SetLocalString(oPC, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(TIME_DAY), resref);
      }
      resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(TIME_NIGHT));
      if(resref != "")
      {
        SetLocalString(oPC, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(TIME_NIGHT), resref);
      }
      string switchSubraceName = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_SWITCH_NAME + IntToString(Level));
      if(switchSubraceName != "")
      {
          SetLocalString(oPC, SubraceTag + "_" + SUBRACE_SWITCH_NAME + IntToString(Level), switchSubraceName);
          int requirements = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_SWITCH_MUST_MEET_REQUIREMENTS + IntToString(Level));
          if(requirements)
          {
                SetLocalInt(oPC, SubraceTag + "_" + SUBRACE_SWITCH_MUST_MEET_REQUIREMENTS + IntToString(Level), requirements);
          }
      }
      Level++;
    }

    //Load all creature claws.
    Level = 1;
    while(Level <= MAXIMUM_PLAYER_LEVEL)
    {
      string resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(Level) + "_" + IntToString(TIME_BOTH));
      if(resref != "")
      {
        SetLocalString(oPC, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(Level) + "_" + IntToString(TIME_BOTH), resref);
      }
      resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(Level)  + "_" + IntToString(TIME_BOTH));
      if(resref != "")
      {
        SetLocalString(oPC, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(Level)  + "_" + IntToString(TIME_BOTH), resref);
      }

      resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(Level) + "_" + IntToString(TIME_DAY));
      if(resref != "")
      {
        SetLocalString(oPC, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(Level) + "_" + IntToString(TIME_DAY), resref);
      }
      resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(Level)  + "_" + IntToString(TIME_DAY));
      if(resref != "")
      {
        SetLocalString(oPC, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(Level)  + "_" + IntToString(TIME_DAY), resref);
      }

      resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(Level) + "_" + IntToString(TIME_NIGHT));
      if(resref != "")
      {
        SetLocalString(oPC, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(Level) + "_" + IntToString(TIME_NIGHT), resref);
      }
      resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(Level)  + "_" + IntToString(TIME_NIGHT));
      if(resref != "")
      {
        SetLocalString(oPC, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(Level)  + "_" + IntToString(TIME_NIGHT), resref);
      }

      Level++;
    }


    int iDmgTakenInLight = GetLocalInt(oStorer, SubraceTag + "_" + DAMAGE_AMOUNT_IN_LIGHT);
    int iDmgTakenInUnder = GetLocalInt(oStorer, SubraceTag + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND);

    SetLocalString(oPC, SUBRACE_TAG,  subraceName);

    int BaseFlags =  GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_FLAGS);
    SetLocalGroupFlagValue(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, BaseFlags, SUBRACE_BASE_INFORMATION_FLAGS);

    if(iDmgTakenInLight != 0)
    {
        SetLocalInt(oPC, SubraceTag + "_" + DAMAGE_AMOUNT_IN_LIGHT, iDmgTakenInLight);
    }

    if(iDmgTakenInUnder != 0)
    {
       SetLocalInt(oPC, SubraceTag + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND, iDmgTakenInUnder);
    }




    Level = 1;
    while(Level <= MAXIMUM_PLAYER_LEVEL)
    {
        string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
        if(GetLocalInt(oStorer, SubraceTag1 + "_" + APPEARANCE_CHANGE) != 0)
        {
           int iTime = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + APPEARANCE_CHANGE,TIME_FLAGS);
           int MaleAppearance = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + APPEARANCE_TO_CHANGE, APPEARANCE_CHANGE_MALE_FLAG);
           int FemaleAppearance = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + APPEARANCE_TO_CHANGE, APPEARANCE_CHANGE_FEMALE_FLAG);
           if(iTime != 0 && (MaleAppearance != 0 || FemaleAppearance !=0))
           {
               SetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + APPEARANCE_CHANGE, iTime ,TIME_FLAGS);
               if(GetGender(oPC) == GENDER_MALE)
               {
                   SetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + APPEARANCE_TO_CHANGE, MaleAppearance, APPEARANCE_CHANGE_APPEARANCE_FLAG);
               }
               else
               {
                   SetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + APPEARANCE_TO_CHANGE, FemaleAppearance, APPEARANCE_CHANGE_APPEARANCE_FLAG);
               }
           }
        }

        if(ENABLE_LETO)
        {
            if(GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS) != 0)
            {
                int Male_Wings = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, SUBRACE_ATTACHMENT_FLAGS_WINGS_MALE);
                int Female_Wings = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, SUBRACE_ATTACHMENT_FLAGS_WINGS_FEMALE);
                int Male_Tail = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, SUBRACE_ATTACHMENT_FLAGS_TAIL_MALE);
                int Female_Tail = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, SUBRACE_ATTACHMENT_FLAGS_TAIL_FEMALE);

                if(GetGender(oPC) == GENDER_MALE)
                {
                     SetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, Male_Wings, SUBRACE_ATTACHMENT_FLAGS_WINGS);
                     SetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, Male_Tail, SUBRACE_ATTACHMENT_FLAGS_TAIL);
                }
                else
                {
                     SetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, Female_Wings, SUBRACE_ATTACHMENT_FLAGS_WINGS);
                     SetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, Female_Tail, SUBRACE_ATTACHMENT_FLAGS_TAIL);
                }
            }
        }

        Level++;
     }



    SubraceTag = SUBRACE_TAG + "_" + subraceName;
    if(ENABLE_LETO)
    {
        Level = 1;
        while(Level <= MAXIMUM_PLAYER_LEVEL)
        {
            string SubraceTag1 = SubraceTag + "_" + IntToString(Level);

            int FeatCount = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BONUS_FEAT_COUNT);
            SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_FEAT_COUNT, FeatCount);
            while(FeatCount != 0)
            {
                int FeatData = GetLocalInt(oStorer, SubraceTag1 + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS);
                SetLocalInt(oPC, SubraceTag1 + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS, FeatData);
                FeatCount--;
            }

            //Skills
            int SkillCount = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BONUS_SKILL_COUNT);
            SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_SKILL_COUNT, SkillCount);
            while(SkillCount != 0)
            {
                int SkillData = GetLocalInt(oStorer, SubraceTag1 + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS);
                SetLocalInt(oPC, SubraceTag1 + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SkillData);
                SkillCount--;
            }

            //Portraits
            string MalePortrait = GetLocalString(oStorer, SubraceTag1 + "_" + SUBRACE_PORTRAIT_MALE);
            string FemalePortrait = GetLocalString(oStorer, SubraceTag1 + "_" + SUBRACE_PORTRAIT_FEMALE);
            if(MalePortrait != "" || FemalePortrait != "")
            {
                if(Gender == GENDER_MALE && MalePortrait != "")
                {
                   SetLocalString(oPC, SubraceTag1 + "_" + SUBRACE_PORTRAIT, MalePortrait);
                }
                else if(Gender == GENDER_FEMALE && FemalePortrait != "")
                {
                   SetLocalString(oPC, SubraceTag1 + "_" + SUBRACE_PORTRAIT, FemalePortrait);
                }
            }
            //Soundsets
            int MaleSoundSet = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + SUBRACE_SOUNDSET_FLAGS, SUBRACE_SOUNDSET_MALE_FLAG);
            int FemaleSoundSet = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + SUBRACE_SOUNDSET_FLAGS, SUBRACE_SOUNDSET_FEMALE_FLAG);
            if(MaleSoundSet != 0 || FemaleSoundSet != 0)
            {
                if(Gender == GENDER_MALE && MaleSoundSet != 0)
                {
                   SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_SOUNDSET_FLAGS, MaleSoundSet);
                }
                else if(Gender == GENDER_FEMALE && FemaleSoundSet != 0)
                {
                   SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_SOUNDSET_FLAGS, FemaleSoundSet);
                }
            }

            Level++;
        }
    }


    SubraceTag = SUBRACE_TAG + "_" + subraceName;
    if(ENABLE_LETO)
    {
        Level = 1;
        while(Level <= MAXIMUM_PLAYER_LEVEL)
        {
              string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
              int HasBStatMod = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_HAS_BASE_STAT_MODIFIERS);
              if(HasBStatMod)
              {
                   SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_HAS_BASE_STAT_MODIFIERS, TRUE);
                   int Set = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BASE_STAT_MODIFIERS_REPLACE);
                   int StrengthModifier = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BASE_STAT_STR_MODIFIER);
                   int DexterityModifier = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BASE_STAT_DEX_MODIFIER);
                   int ConstitutionModifier =  GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BASE_STAT_CON_MODIFIER);
                   int IntelligenceModifier =  GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BASE_STAT_INT_MODIFIER);
                   int WisdomModifier =  GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BASE_STAT_WIS_MODIFIER);
                   int CharismaModifier =  GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BASE_STAT_CHA_MODIFIER);
                   int SpdMod =   GetLocalInt(oStorer, SubraceTag1  + "_" + SUBRACE_BASE_STAT_SPD_MODIFIER);
                   //int HPMod = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_BASE_STAT_HP_MODIFIER);

                   if(StrengthModifier != 0)
                   {
                        SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_STR_MODIFIER, StrengthModifier);
                   }
                   if(DexterityModifier != 0)
                   {
                        SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_DEX_MODIFIER, DexterityModifier);
                   }
                   if(ConstitutionModifier != 0)
                   {
                        SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_CON_MODIFIER, ConstitutionModifier);
                   }
                   if(WisdomModifier != 0)
                   {
                        SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_WIS_MODIFIER, WisdomModifier);
                   }
                   if(IntelligenceModifier != 0)
                   {
                        SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_INT_MODIFIER, IntelligenceModifier);
                   }
                   if(CharismaModifier != 0)
                   {
                        SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_CHA_MODIFIER, CharismaModifier);
                   }
                   if(SpdMod != 0)
                   {
                        SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_SPD_MODIFIER, SpdMod);
                   }
                  /* if(HPMod != 0)
                   {
                        SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_HP_MODIFIER, HPMod);
                   }  */
                   if(Set)
                   {
                        SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_MODIFIERS_REPLACE, Set);
                   }
             }
             Level++;
       }
    }


    SubraceTag = SUBRACE_TAG + "_" + subraceName;
    int HasDiffStats = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG1);
    SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG1, HasDiffStats);
    if(HasDiffStats)
    {
        //day
        int iTime = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG2);
        SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG2, iTime);

       if(iTime)
       {
           SubraceTag = SubraceTag + IntToString(TIME_DAY);

           int ModType = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIER_TYPE);

           int AreaInt = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG4);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG4, AreaInt);
           int AreaExt = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG5);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG5, AreaExt);

           int AreaUnd = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG9);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG9, AreaUnd);
           int AreaAbove = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG8);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG8, AreaAbove);

           int AreaArt = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG6);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG6, AreaArt);
           int AreaNat = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG7);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG7, AreaNat);

           float StrengthModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER);
           float DexterityModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER);
           float ConstitutionModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER);
           float WisdomModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER);
           float IntelligenceModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER);
           float CharismaModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER);

           float ABModifier = GetLocalFloat(oStorer, SubraceTag  + "_" + SUBRACE_STAT_AB_MODIFIER);
           float ACModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER);

           SetLocalInt(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIER_TYPE, ModType);

           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER, StrengthModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER, DexterityModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER, ConstitutionModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER, WisdomModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER, IntelligenceModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER, CharismaModifier);

           SetLocalFloat(oPC, SubraceTag  + "_" + SUBRACE_STAT_AB_MODIFIER, ABModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER, ACModifier);
       }

       SubraceTag = SUBRACE_TAG + "_" + subraceName;
       //night
       iTime = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG3);
       SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG3, iTime);
       if(iTime)
       {

           SubraceTag = SubraceTag + IntToString(TIME_NIGHT);


           int AreaInt = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG4);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG4, AreaInt);
           int AreaExt = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG5);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG5, AreaExt);

           int AreaUnd = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG9);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG9, AreaUnd);
           int AreaAbove = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG8);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG8, AreaAbove);

           int AreaArt = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG6);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG6, AreaArt);
           int AreaNat = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG7);
           SetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG7, AreaNat);


           float StrengthModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER);
           float DexterityModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER);
           float ConstitutionModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER);
           float WisdomModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER);
           float IntelligenceModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER);
           float CharismaModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER);

           float ABModifier = GetLocalFloat(oStorer, SubraceTag  + "_" + SUBRACE_STAT_AB_MODIFIER);
           float ACModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER);
           int ModType = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIER_TYPE);
           SetLocalInt(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIER_TYPE, ModType);

           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER, StrengthModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER, DexterityModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER, ConstitutionModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER, WisdomModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER, IntelligenceModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER, CharismaModifier);

           SetLocalFloat(oPC, SubraceTag  + "_" + SUBRACE_STAT_AB_MODIFIER, ABModifier);
           SetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER, ACModifier);
       }

    }
    SubraceTag = SUBRACE_TAG + "_" + subraceName;

    int HasRes = GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_HAS_RESTRICTION, SUBRACE_RESTRICTION_FLAGS);

    if(HasRes)
    {
         int WepResData = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION);
         SetLocalInt(oPC, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, WepResData);
    }

    HasRes = GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, SUBRACE_HAS_RESTRICTION, SUBRACE_RESTRICTION_FLAGS);
   if(HasRes)
    {
         int DefResData = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION);
         SetLocalInt(oPC, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, DefResData);
    }

    Count = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_EFFECT_COUNT);
    if(Count != 0 )
    {
      SetLocalInt(oPC, SubraceTag + "_" + SUBRACE_EFFECT_COUNT, Count);
      int i = 0;
      while(i != Count)
      {
          i++;
          string SubraceTag1 = SubraceTag + IntToString(i);
          int Effect = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_EFFECT);
          int Value1 = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_EFFECT_VALUE_1);
          int Value2 = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_EFFECT_VALUE_2);
          int TimeOfDay = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_EFFECT_APPLY_TIME);
          int DurationType = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_EFFECT_DURATION_TYPE);
          float fDuration = GetLocalFloat(oStorer, SubraceTag1 + "_" + SUBRACE_EFFECT_DURATION);
          SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT, Effect);
          SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_VALUE_1, Value1);
          SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_VALUE_2, Value2);
          SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_DURATION_TYPE, DurationType);
          SetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_APPLY_TIME, TimeOfDay);
          SetLocalFloat(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_DURATION, fDuration);
      }
    }
    int HasFClass = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_FAVORED_CLASS);

    if(HasFClass != 0)
    {
       int MaleFavoredClass = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_FAVORED_CLASS, SUBRACE_FAVORED_CLASS_MALE_FLAG);
       int FemaleFavoredClass = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_FAVORED_CLASS, SUBRACE_FAVORED_CLASS_FEMALE_FLAG);
       if(GetGender(oPC) == GENDER_MALE)
       {
           SetLocalInt(oPC, SUBRACE_FAVORED_CLASS, MaleFavoredClass);
       }
       else
       {
           SetLocalInt(oPC, SUBRACE_FAVORED_CLASS, FemaleFavoredClass);
       }
    }



    GiveSubraceUniqueItem(SubraceTag, oPC);

    DelayCommand(3.0, SetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC, TRUE));
    DelayCommand(12.0, SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_DATA_LOADED, FALSE));

    Level = GetPlayerLevel(oPC);
    int NeedsToRelog = CheckForLetoReLog(oPC, Level);
    if(NeedsToRelog)
    {
       if(!LETO_ACTIVATE_PORTAL)
       {
           DelayCommand(24.0, PopUpDeathGUIPanel(oPC, FALSE, FALSE, 0, SUBRACE_ENGINE + MESSAGE_LETO_PLEASE_RELOG));
           if(LETO_AUTOMATICALLY_BOOT)
           {
               DelayCommand(24.2, SHA_SendSubraceMessageToPC(oPC, MESSAGE_LETO_AUTOBOOT1 + IntToString(LETO_AUTOMATIC_BOOT_DELAY) + MESSAGE_LETO_AUTOBOOT2));
               DelayCommand(24.2 + IntToFloat(LETO_AUTOMATIC_BOOT_DELAY), DelayBoot(oPC));
           }
       }
       else
       {
              if(!LETO_PORTAL_KEEP_CHARACTER_IN_THE_SAME_PLACE)
              {
                  DelayCommand(24.2, SHA_SendSubraceMessageToPC(oPC, MESSAGE_LETO_AUTOPORTAL + IntToString(LETO_AUTOMATIC_PORTAL_DELAY) + MESSAGE_LETO_AUTOBOOT2));
                  DelayCommand(24.2 + IntToFloat(LETO_AUTOMATIC_PORTAL_DELAY), ActivatePortal(oPC, LETO_PORTAL_IP_ADDRESS, LETO_PORAL_SERVER_PASSWORD, LETO_PORTAL_WAYPOINT, TRUE));
              }
              else
              {
                   int RandomNumber = d100(1);
                   object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, "WP_SUBRACE_P" + IntToString(RandomNumber));
                   string sWPTag = "WP_SUBRACE_P" + IntToString(RandomNumber);
                   DelayCommand(24.2, SHA_SendSubraceMessageToPC(oPC, MESSAGE_LETO_DONT_PANIC_JUSTPORTING));
                   DelayCommand(32.0, ActivatePortal(oPC, LETO_PORTAL_IP_ADDRESS, LETO_PORAL_SERVER_PASSWORD, sWPTag, TRUE));
                   DelayCommand(36.0, DestroyObject(oWaypoint, 0.1));
              }
       }

       DelayCommand(24.0, SetSubraceDBInt(SUBRACE_DATABASE, SUBRACE_TAG + LETO_CHANGES_MADE_FOR_THIS_LEVEL, Level, oPC));
    }


}

void DeleteSubraceInfoOnPC(object oPC)
{
    string subraceName = GetStringLowerCase(GetSubRace(oPC));
    string SubraceTag = SUBRACE_TAG + "_" + subraceName;
    if(subraceName == "")
    { return; }
    SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_PURGING, FALSE);
    ClearSubraceTemporaryStats(oPC);
    ClearSubraceEffects(oPC);
    ChangeToPCDefaultAppearance(oPC);
    effect iEffect = GetFirstEffect(oPC);
    while(GetIsEffectValid(iEffect))
    {
         int iEffectType = GetEffectType(iEffect);
         if(iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
         iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE)
         {
             RemoveEffect(oPC, iEffect);
         }
      iEffect = GetNextEffect(oPC);
    }

    DeleteLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC);

    int Level = 1;
    while(Level <= MAXIMUM_PLAYER_LEVEL)
    {
        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(Level) + "_" + IntToString(TIME_BOTH));
        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(Level)  + "_" + IntToString(TIME_BOTH));
        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(Level) + "_" + IntToString(TIME_DAY));
        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(Level)  + "_" + IntToString(TIME_DAY));
        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_LEFT_CLAW + "_" + IntToString(Level) + "_" + IntToString(TIME_NIGHT));
        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_RIGHT_CLAW + "_" + IntToString(Level)  + "_" + IntToString(TIME_NIGHT));

        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_SWITCH_NAME + IntToString(Level));
        DeleteLocalInt(oPC, SubraceTag + "_" + SUBRACE_SWITCH_MUST_MEET_REQUIREMENTS + IntToString(Level));

        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(TIME_BOTH));
        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(TIME_DAY));
        DeleteLocalString(oPC, SubraceTag + "_" + SUBRACE_SKIN + "_" + IntToString(Level) + "_" + IntToString(TIME_NIGHT));

        Level++;
    }

    if(ENABLE_LETO)
    {
        Level = 1;
        while(Level <= MAXIMUM_PLAYER_LEVEL)
        {
           string SubraceTag1 = SubraceTag + "_" + IntToString(Level);

           DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS);

           int FeatCount = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_FEAT_COUNT);
           DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_FEAT_COUNT);
           while(FeatCount != 0)
           {
                DeleteLocalInt(oPC, SubraceTag1 + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS);
                FeatCount--;
           }
           int SkillCount = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_SKILL_COUNT);
           DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_SKILL_COUNT);
           while(SkillCount != 0)
           {
                DeleteLocalInt(oPC, SubraceTag1 + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS);
                SkillCount--;
           }

            DeleteLocalString(oPC, SubraceTag1 + "_" + SUBRACE_PORTRAIT);
            DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_SOUNDSET_FLAGS);

            int HasBStatMod = GetLocalInt(oStorer, SubraceTag1 + "_" + SUBRACE_HAS_BASE_STAT_MODIFIERS);
            if(HasBStatMod)
             {
                   DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_HAS_BASE_STAT_MODIFIERS);
                   DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_STR_MODIFIER);
                   DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_DEX_MODIFIER);
                   DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_CON_MODIFIER);
                   DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_WIS_MODIFIER);
                   DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_WIS_MODIFIER);
                   DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_CHA_MODIFIER);
                   DeleteLocalInt(oPC, SubraceTag1  + "_" + SUBRACE_BASE_STAT_SPD_MODIFIER);
                   DeleteLocalInt(oPC, SubraceTag1  + "_" + SUBRACE_BASE_STAT_HP_MODIFIER);
                   DeleteLocalInt(oPC, SubraceTag1  + "_" + SUBRACE_BASE_STAT_MODIFIERS_REPLACE);
             }
            Level++;
        }
    }
    Level = 40;
    while(Level != 0)
    {
       string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
       DeleteLocalInt(oPC, SubraceTag1 + "_" + APPEARANCE_CHANGE);
       DeleteLocalInt(oPC, SubraceTag1 + "_" + APPEARANCE_TO_CHANGE);
       Level--;
    }
    DeleteLocalInt(oPC, SubraceTag + "_" + DAMAGE_AMOUNT_IN_LIGHT);
    DeleteLocalInt(oPC, SubraceTag + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND);
    DeleteLocalInt(oPC, SubraceTag + "_" +  SUBRACE_BASE_INFORMATION);


    DeleteLocalInt(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS);

    SubraceTag = SubraceTag + IntToString(TIME_DAY);

    DeleteLocalInt(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIER_TYPE);

    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER);

    DeleteLocalFloat(oPC, SubraceTag  + "_" + SUBRACE_STAT_AB_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER);


    SubraceTag = SUBRACE_TAG + "_" + subraceName;

    SubraceTag = SubraceTag + IntToString(TIME_NIGHT);


    DeleteLocalInt(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIER_TYPE);


    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER);

    DeleteLocalFloat(oPC, SubraceTag  + "_" + SUBRACE_STAT_AB_MODIFIER);
    DeleteLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER);

    SubraceTag = SUBRACE_TAG + "_" + subraceName;

    DeleteLocalInt(oPC, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION);


    DeleteLocalInt(oPC, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION);

    int Count = GetLocalInt(oPC, SubraceTag + "_" + SUBRACE_EFFECT_COUNT);
    DeleteLocalInt(oPC, SubraceTag + "_" + SUBRACE_EFFECT_COUNT);
    if(Count != 0)
    {
      int i = 0;
      while(i != Count)
      {
          i++;
          string SubraceTag1 = SubraceTag + IntToString(i);
          DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT);
          DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_VALUE_1);
          DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_VALUE_2);
          DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_DURATION_TYPE);
          DeleteLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_APPLY_TIME);
          DeleteLocalFloat(oPC, SubraceTag1 + "_" + SUBRACE_EFFECT_DURATION);
      }
    }
    DeleteLocalInt(oPC, SUBRACE_FAVORED_CLASS);

    object Skin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    SetPlotFlag(Skin, FALSE);
    DestroyObject(Skin, 0.1);

    object ClawLeft =  GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    object ClawRight = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    SetPlotFlag(ClawLeft, FALSE);
    SetPlotFlag(ClawRight, FALSE);
    DestroyObject(ClawLeft, 0.5);
    DestroyObject(ClawRight, 0.5);

   int SubraceUniqueItemCount = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_UNIQUEITEM_COUNT);
    int i = 0;
    while(i <= SubraceUniqueItemCount)
    {
       i++;
       string resref = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_UNIQUEITEM + "_" + IntToString(i));
       if(resref != "")
       {
           string sLevel = GetStringRight(resref, 2);
           if(GetStringLeft(sLevel, 1) == "_")
           {
              sLevel = GetStringRight(sLevel, 1);
           }
           int iLevel = StringToInt(sLevel);
           resref = GetStringLeft(resref, GetStringLength(resref) - 2);
           if(iLevel <= GetPlayerLevel(oPC))
           {
               object oItem = GetFirstItemInInventory(oPC);
               while(GetIsObjectValid(oItem))
               {
                   if(GetResRef(oItem) == resref)
                   {
                      SetPlotFlag(oItem, FALSE);
                      DestroyObject(oItem, 0.1);
                   }
                  oItem = GetNextItemInInventory(oPC);
               }
           }
      }
    }
   DeleteLocalInt(oPC, SUBRACE_TAG + "SB_NITE_OCE");
   DeleteLocalInt(oPC, SUBRACE_TAG + "SB_DAY_OCE");
   DeleteLocalInt(oPC, APPEARANCE_TEMP_CHANGED);
   DeleteLocalInt(oPC, SUBRACE_IN_SPELL_DARKNESS);
   DeleteLocalInt(oPC, "SUB_EFCT_D_APD");
   DeleteLocalInt(oPC, "SUB_EFCT_N_APD");

   DeleteLocalInt(oPC,"SB_LGHT_DMGED");

   DeleteLocalInt(oPC,"SB_DARK_DMGED");

   DeleteLocalInt(oPC, SUBRACE_STATS_STATUS);
   DelayCommand(4.0, SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_PURGED, FALSE));

}


void SHA_SubraceReadSubrace(object oDM, string sStuff)
{
    SendMessageToPC(oDM, sStuff);
   //PrintString(sStuff);
}
void ReadAllSubraces(object oDM)
{
   //Save the count, and the name of the subrace.
    int iCount = GetLocalInt(oStorer, MODULE_SUBRACE_COUNT);
    SHA_SubraceReadSubrace(oDM, "--------- Module Subraces ----------");
    ReadSubrace(oDM, iCount, 1);


}

void ReadSubrace(object oDM, int MaxCount, int CurrentCount)
{
  if(CurrentCount <= MaxCount)
  {
     string subraceName = GetLocalString(oStorer, MODULE_SUBRACE_NUMBER + IntToString(CurrentCount));
     string Name = GetStringUpperCase(GetStringLeft(subraceName, 1)) + GetStringRight(subraceName, GetStringLength(subraceName) - 1);
     SHA_SubraceReadSubrace(oDM, IntToString(CurrentCount) + ".");
     SHA_SubraceReadSubrace(oDM, "  <ck�u>Subrace: </c>" + Name);
     ReadSubraceInformation(subraceName, oDM);
     SHA_SubraceReadSubrace(oDM, " ");
     CurrentCount++;
     DelayCommand(0.1, ReadSubrace(oDM, MaxCount, CurrentCount));
  }
  if(CurrentCount == MaxCount)
  {
    DelayCommand(0.2, SHA_SubraceReadSubrace(oDM, "--------- End Module Subraces --------"));
    DelayCommand(0.2,SHA_SubraceReadSubrace(oDM, "-- Total Subrace Count: " + IntToString(MaxCount)));
  }

}

void ReadSubraceInformation(string subraceName, object oDM, object oTarget = OBJECT_INVALID)
{
     string SubraceTag = SUBRACE_TAG + "_" + subraceName;
     if(subraceName == "")
     {
         SHA_SubraceReadSubrace(oDM, "   This player character is not part of a subrace.");
         return;
     }
     if(oTarget != OBJECT_INVALID)
     {
         SHA_SubraceReadSubrace(oDM, "  <ck�u>Player Subrace: </c>" + CapitalizeString(subraceName));
         SHA_SubraceReadSubrace(oDM, "      Race: " + race(GetRacialType(oTarget)));
         if(!GetLocalInt(oStorer, SubraceTag))
         {
            SHA_SubraceReadSubrace(oDM, "   This subrace is not supported by this world.");
            return;
         }
     }
     else
     {
         SHA_SubraceReadSubrace(oDM, "      Races that qualify: ");
         if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG1, SUBRACE_BASE_RACE_FLAGS))
         {
             SHA_SubraceReadSubrace(oDM, "          Dwarf");
         }
         if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG2, SUBRACE_BASE_RACE_FLAGS))
         {
             SHA_SubraceReadSubrace(oDM, "          Elf");
         }
         if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG3, SUBRACE_BASE_RACE_FLAGS))
         {
             SHA_SubraceReadSubrace(oDM, "          Gnome");
         }
         if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG4, SUBRACE_BASE_RACE_FLAGS))
         {
            SHA_SubraceReadSubrace(oDM, "          Half-elf");
         }
         if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG5, SUBRACE_BASE_RACE_FLAGS))
         {
            SHA_SubraceReadSubrace(oDM, "          Halfling");
         }
         if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG6, SUBRACE_BASE_RACE_FLAGS))
         {
             SHA_SubraceReadSubrace(oDM, "          Half-Orc");
         }
         if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_RACE, FLAG7, SUBRACE_BASE_RACE_FLAGS))
         {
             SHA_SubraceReadSubrace(oDM, "          Human");
         }
     }
     SHA_SubraceReadSubrace(oDM, " ");

     SHA_SubraceReadSubrace(oDM, "      Base information: ");

     int iDmgTakenInLight = GetLocalInt(oStorer, SubraceTag + "_" + DAMAGE_AMOUNT_IN_LIGHT);
     int iDmgTakenInUnder = GetLocalInt(oStorer, SubraceTag + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND);


    if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS))
    {
       SHA_SubraceReadSubrace(oDM, "            *Light Sensitive");
    }
    if(iDmgTakenInLight != 0)
    {
        if(iDmgTakenInLight > 0)
        {
           SHA_SubraceReadSubrace(oDM, "            *Takes " + IntToString(iDmgTakenInLight) + " damage in sunlight.");
        }
        else
        {
           SHA_SubraceReadSubrace(oDM, "            *Regenerates " + IntToString(abs(iDmgTakenInLight)) + " hitpoints in sunlight.");
        }
    }
    if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS))
    {
       SHA_SubraceReadSubrace(oDM, "            *Underground Sensitive");
    }
    if(iDmgTakenInUnder != 0)
    {
        if(iDmgTakenInUnder > 0)
        {
           SHA_SubraceReadSubrace(oDM, "            *Takes " + IntToString(iDmgTakenInUnder) + " damage in underground.");
        }
        else
        {
           SHA_SubraceReadSubrace(oDM, "            *Regenerates " + IntToString(abs(iDmgTakenInUnder)) + " hitpoints in underground areas.");
        }
    }
    if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDEAD, SUBRACE_BASE_INFORMATION_FLAGS))
    {
       SHA_SubraceReadSubrace(oDM, "            *Undead subrace");
    }
    if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_PRESTIGIOUS_SUBRACE, SUBRACE_BASE_INFORMATION_FLAGS))
    {
       SHA_SubraceReadSubrace(oDM, "            *Prestigious subrace");
    }
    int ECL = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_ECL);
    if(ECL != 0)
    {
       SHA_SubraceReadSubrace(oDM, "            *ECL: " + IntToString(ECL));
    }
     SHA_SubraceReadSubrace(oDM, " ");
    int HasFClass = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_FAVORED_CLASS);

    if(HasFClass != 0)
    {
       SHA_SubraceReadSubrace(oDM, "            *Favored Classs:");
       int MaleFavoredClass = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_FAVORED_CLASS, SUBRACE_FAVORED_CLASS_MALE_FLAG);
       int FemaleFavoredClass = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_FAVORED_CLASS, SUBRACE_FAVORED_CLASS_FEMALE_FLAG);
       SHA_SubraceReadSubrace(oDM, "               Male: " + class(MaleFavoredClass - 1));
       SHA_SubraceReadSubrace(oDM, "               Female: " + class(FemaleFavoredClass - 1));
        SHA_SubraceReadSubrace(oDM, " ");
   }

    int Level = 1;
    while(Level <=40)
    {
        string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
        if(GetLocalInt(oStorer, SubraceTag1 + "_" + APPEARANCE_CHANGE) != 0)
        {
           SHA_SubraceReadSubrace(oDM, "        Appearance is altered.");
           SHA_SubraceReadSubrace(oDM, " ");
           break;
        }
        Level++;

     }

    int HasDiffStats = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG1);

    if(HasDiffStats)
    {
       SHA_SubraceReadSubrace(oDM, "        Ability scores change:");
        //day
       int iTime = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG2);
       if(iTime)
       {
           SubraceTag = SubraceTag + IntToString(TIME_DAY);
           SHA_SubraceReadSubrace(oDM, "           For day time:");
           int ModType = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIER_TYPE);
           float multiplier = 1.0;
           string percent = "";
           if(ModType ==  SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE)
           {
              multiplier = 100.0;
              percent = "%";
           }

           float StrengthModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER);
           float DexterityModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER);
           float ConstitutionModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER);
           float WisdomModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER);
           float IntelligenceModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER);
           float CharismaModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER);

           float ABModifier = GetLocalFloat(oStorer, SubraceTag  + "_" + SUBRACE_STAT_AB_MODIFIER);
           float ACModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER);

           SHA_SubraceReadSubrace(oDM, "              STR: " + FloatToString(multiplier*StrengthModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              DEX: " + FloatToString(multiplier*DexterityModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              CON: " + FloatToString(multiplier*ConstitutionModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              WIS: " + FloatToString(multiplier*WisdomModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              INT: " + FloatToString(multiplier*IntelligenceModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              CHA: " + FloatToString(multiplier*CharismaModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              AB : " + FloatToString(multiplier*ABModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              AC : " + FloatToString(multiplier*ACModifier, 18, 2) + percent);

           SHA_SubraceReadSubrace(oDM, "           Changes happen in:");
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG4))
           {
              SHA_SubraceReadSubrace(oDM, "              Interior Areas");
           }

           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG5))
           {
              SHA_SubraceReadSubrace(oDM, "              Exterior Areas");
           }
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG9))
           {
              SHA_SubraceReadSubrace(oDM, "              Underground Areas");
           }
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG8))
           {
              SHA_SubraceReadSubrace(oDM, "              Above-ground Areas");
           }
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG6))
           {
              SHA_SubraceReadSubrace(oDM, "              Artificial Areas");
           }
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG7))
           {
              SHA_SubraceReadSubrace(oDM, "              Natural Areas");
           }
       }

       SubraceTag = SUBRACE_TAG + "_" + subraceName;
       //night
       iTime = GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG3);
       if(iTime)
       {

           SubraceTag = SubraceTag + IntToString(TIME_NIGHT);
           SHA_SubraceReadSubrace(oDM, "           For night time:");
           int ModType = GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIER_TYPE);
           float multiplier = 1.0;
           string percent = "";
           if(ModType ==  SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE)
           {
              multiplier = 100.0;
              percent = "%";
           }

           float StrengthModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER);
           float DexterityModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER);
           float ConstitutionModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER);
           float WisdomModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER);
           float IntelligenceModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER);
           float CharismaModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER);

           float ABModifier = GetLocalFloat(oStorer, SubraceTag  + "_" + SUBRACE_STAT_AB_MODIFIER);
           float ACModifier = GetLocalFloat(oStorer, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER);

           SHA_SubraceReadSubrace(oDM, "              STR: " + FloatToString(multiplier*StrengthModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              DEX: " + FloatToString(multiplier*DexterityModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              CON: " + FloatToString(multiplier*ConstitutionModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              WIS: " + FloatToString(multiplier*WisdomModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              INT: " + FloatToString(multiplier*IntelligenceModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              CHA: " + FloatToString(multiplier*CharismaModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              AB : " + FloatToString(multiplier*ABModifier, 18, 2) + percent);
           SHA_SubraceReadSubrace(oDM, "              AC : " + FloatToString(multiplier*ACModifier, 18, 2) + percent);

           SHA_SubraceReadSubrace(oDM, "           Changes happen in:");
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG4))
           {
              SHA_SubraceReadSubrace(oDM, "              Interior Areas");
           }

           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG5))
           {
              SHA_SubraceReadSubrace(oDM, "              Exterior Areas");
           }
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG9))
           {
              SHA_SubraceReadSubrace(oDM, "              Underground Areas");
           }
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG8))
           {
              SHA_SubraceReadSubrace(oDM, "              Above-ground Areas");
           }
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG6))
           {
              SHA_SubraceReadSubrace(oDM, "              Artificial Areas");
           }
           if(GetLocalFlag(oStorer, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG7))
           {
              SHA_SubraceReadSubrace(oDM, "              Natural Areas");
           }
       }
      SHA_SubraceReadSubrace(oDM, " ");
    }
    SubraceTag = SUBRACE_TAG + "_" + subraceName;

    int HasRes = GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_HAS_RESTRICTION, SUBRACE_RESTRICTION_FLAGS);

    if(HasRes)
    {
       SHA_SubraceReadSubrace(oDM, "        Subrace has weapon restrictions: ");
       int ResType = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_RESTRICTION_WEAPON);
       int ResTime = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, TIME_FLAGS);
       int Allow = GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_ALLOW_ONLY_THIS_TYPE, SUBRACE_RESTRICTION_FLAGS);

       string isonly = "Not allowed to use ";
       if(Allow)
       {
          isonly = "Is only allowed to use ";
       }

       SHA_SubraceReadSubrace(oDM, "           -" + isonly + " " + Subrace_WeaponRestrictionToString(ResType));
       SHA_SubraceReadSubrace(oDM, "           -Restriction applies during: " + Subrace_TimeToString(ResTime));
       SHA_SubraceReadSubrace(oDM, " ");
    }

    HasRes = GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, SUBRACE_HAS_RESTRICTION, SUBRACE_RESTRICTION_FLAGS);
    if(HasRes)
    {
       SHA_SubraceReadSubrace(oDM, "        Subrace has armor/shield restrictions:");
       string isonly = "";
       if(GetLocalGroupFlag(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, SUBRACE_ALLOW_ONLY_THIS_TYPE, SUBRACE_RESTRICTION_FLAGS))
       {
          isonly = "Is only allowed to use ";
       }
       int ResType = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, SUBRACE_RESTRICTION_DEFENSE);
       int ResTime = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, TIME_FLAGS);
       SHA_SubraceReadSubrace(oDM, "           -" + isonly + Subrace_DefenseRestrictionToString(ResType));
       SHA_SubraceReadSubrace(oDM, "           -Restriction applies during: " + Subrace_TimeToString(ResTime));
       SHA_SubraceReadSubrace(oDM, " ");
    }

}
string Subrace_TimeToString(int iTime)
{
   string ret = "ERROR";
   switch(iTime)
   {
       case TIME_DAY: ret = "Day time"; break;
       case TIME_NIGHT: ret = "Night time"; break;
       case TIME_BOTH: ret = "Day & Night time"; break;
       case TIME_NONE: ret = "None - Special"; break;
       default: break;
   }
   return ret;
}

void ChangePCAppearance(object oPC, string SubraceTag)
{
   int App = GetLocalGroupFlagValue(oPC, SubraceTag + "_" + APPEARANCE_TO_CHANGE, APPEARANCE_CHANGE_APPEARANCE_FLAG);
   if(App == GetAppearanceType(oPC))
   { return; }
   int Alignment = GetAlignmentGoodEvil(oPC);
   int VFX_ID = VFX_IMP_UNSUMMON;
   if(Alignment == ALIGNMENT_GOOD)
   {
       VFX_ID = VFX_IMP_GOOD_HELP;
   }
   else if (Alignment == ALIGNMENT_NEUTRAL)
   {
        VFX_ID = VFX_FNF_SUMMON_MONSTER_3;
   }
   else if (Alignment == ALIGNMENT_EVIL)
   {
        VFX_ID = VFX_IMP_EVIL_HELP;
   }
   effect VisualBurst = EffectVisualEffect(VFX_ID);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, VisualBurst, oPC);

   if(PC_SCREAMS_WHEN_CHANGING_IN_APPEARANCE)
   {
     AssignCommand(oPC, SpeakString(SUBRACE_WORDS_SPOKEN_ON_APPEARANCE_CHANGE_TO_MONSTER));
   }
   SetCreatureAppearanceType(oPC, App);
   if(GetAppearanceType(oPC) == App)
   { SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_APPEARANCE_CHANGED, FALSE); }
}

void ChangeToPCDefaultAppearance(object oPC)
{
   int App = SHA_GetDefaultAppearanceType(oPC);
   if(App == GetAppearanceType(oPC))
   { return; }

   int Alignment = GetAlignmentGoodEvil(oPC);
   int VFX_ID = VFX_IMP_UNSUMMON;
   if(Alignment == ALIGNMENT_GOOD)
   {
       VFX_ID = VFX_IMP_GOOD_HELP;
   }
   else if (Alignment == ALIGNMENT_NEUTRAL)
   {
        VFX_ID = VFX_FNF_SUMMON_MONSTER_3;
   }
   else if (Alignment == ALIGNMENT_EVIL)
   {
        VFX_ID = VFX_IMP_EVIL_HELP;
   }
   effect VisualBurst = EffectVisualEffect(VFX_ID);

   if(PC_SCREAMS_WHEN_CHANGING_IN_APPEARANCE)
   {
        AssignCommand(oPC, SpeakString(SUBRACE_WORDS_SPOKEN_ON_APPEARANCE_CHANGE_TO_DEFAULT_RACIAL_TYPE));
   }
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, VisualBurst, oPC);
   SetCreatureAppearanceType(oPC, App);
   SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_APPEARANCE_REVERTED, FALSE);
}


void ApplyPermanentSubraceAppearance(string subrace, object oPC)
{
    string SubraceTag = SUBRACE_TAG + "_" + subrace;
    int Level = GetPlayerLevel(oPC);
    while(Level != 0)
    {
        string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
        int iTime = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + APPEARANCE_CHANGE, TIME_FLAGS);
        if(iTime == TIME_BOTH)
        {
            ChangePCAppearance(oPC, SubraceTag1);
            return;
        }
        Level--;
    }
    ChangeToPCDefaultAppearance(oPC);
}

void ApplyTemporarySubraceAppearance(string SubraceTag, object oPC, int iCurrentTime)
{
   int Level = GetPlayerLevel(oPC);
   while(Level != 0)
   {
       string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
       int iTime = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + APPEARANCE_CHANGE, TIME_FLAGS);
       if(iTime != 0 && iTime != TIME_NONE)
       {
           if(iTime == TIME_BOTH)
           {  }
           else if(iTime == iCurrentTime)
           {
                ChangePCAppearance(oPC, SubraceTag1);
           }
           else if(iTime != iCurrentTime)
           {
                ChangeToPCDefaultAppearance(oPC);
           }
           return;
       }
       Level--;
   }
}



void ApplyPermanentSubraceSpellResistance(string subrace, object oPC)
{
   string SubraceTag = SUBRACE_TAG + "_" + subrace;


    if(GetLocalInt(oStorer, SubraceTag + "_" + SUBRACE_SPELL_RESISTANCE) == 0)
    { return; }

    //Remove all spell resistances so we can get the correct base spell resistance
    //given by items
    if(SUBRACE_SPELL_RESISTANCE_STACKS && (GetHasSpellEffect(SPELL_SPELL_RESISTANCE, oPC) || GetHasSpellEffect(SPELL_GREATER_SPELL_BREACH, oPC)))
    {
        effect iEffect = GetFirstEffect(oPC);
        while(GetIsEffectValid(iEffect))
        {
           int iEffectType = GetEffectType(iEffect);
           if(iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
               iEffectType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE)
               {
                  RemoveEffect(oPC, iEffect);
               }
            iEffect = GetNextEffect(oPC);
        }
    }
    int SpellResAtLevel1 = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_SPELL_RESISTANCE, SUBRACE_SPELL_RESISTANCE_BASE_FLAGS);
    int SpellResAtLevelMax = GetLocalGroupFlagValue(oStorer, SubraceTag + "_" + SUBRACE_SPELL_RESISTANCE, SUBRACE_SPELL_RESISTANCE_MAX_FLAGS);
    float AvgSR;
    effect SpellResistance;
    float baseSR =  IntToFloat(SpellResAtLevel1);
    float maxSR =   IntToFloat(SpellResAtLevelMax);
    AvgSR = maxSR - baseSR;
    float SRPerLevel = AvgSR/IntToFloat(MAXIMUM_PLAYER_LEVEL);
    float PCLevel = IntToFloat(GetPlayerLevel(oPC));
    float SR = (PCLevel*SRPerLevel)+ baseSR;
    int SR_int = FloatToInt(SR);
    if(SUBRACE_SPELL_RESISTANCE_STACKS)
    {
       SR_int = SR_int + GetSpellResistance(oPC);

    }
    if(SR_int < 0)
    {
       int SR1 = abs(SR_int);
       SpellResistance = EffectSpellResistanceDecrease(SR1);
    }
    else
    {
       SpellResistance = EffectSpellResistanceIncrease(SR_int);
    }
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(SpellResistance), oPC);
    SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_SPELL_RESISTANCE_APPLIED, FALSE);
}

void ApplyTemporarySubraceStats(object oPC, string SubraceTag, int iCurrentTime, int AreaUndAbove, int AreaIntExt, int AreaNatArt)
{
   int  iTimeDay =  GetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG2);
   int  iTimeNight =  GetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG3);

   if(iTimeDay || iTimeNight)
   {
       SHA_ApplyTemporaryStats(oPC, SubraceTag, iCurrentTime, iTimeDay, iTimeNight, AreaUndAbove, AreaIntExt, AreaNatArt);
   }
}
void TemporaryStatsVisualFX(object oPC)
{
  effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
  effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
  effect Vfx = EffectLinkEffects(eVis, eDur);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, Vfx, oPC);

}


void SHA_ApplyTemporaryStats(object oPC, string SubraceTag, int iCurrentTime, int iTimeDay, int iTimeNight,int AreaUndAbove, int AreaIntExt, int AreaNatArt)
{
       if(AreaUndAbove == AREA_INVALID)
       {  return; }
       string SubraceTag1 = SubraceTag + IntToString(iCurrentTime);

       int AreaInt = GetLocalFlag(oPC, SubraceTag1 + "_" + SUBRACE_STAT_MODIFIERS, FLAG4);

       int AreaExt = GetLocalFlag(oPC, SubraceTag1 + "_" + SUBRACE_STAT_MODIFIERS, FLAG5);

       int AreaUnd = GetLocalFlag(oPC, SubraceTag1 + "_" + SUBRACE_STAT_MODIFIERS, FLAG9);

       int AreaAbove = GetLocalFlag(oPC, SubraceTag1 + "_" + SUBRACE_STAT_MODIFIERS, FLAG8);

       int AreaArt = GetLocalFlag(oPC, SubraceTag1 + "_" + SUBRACE_STAT_MODIFIERS, FLAG6);

       int AreaNat = GetLocalFlag(oPC, SubraceTag1 + "_" + SUBRACE_STAT_MODIFIERS, FLAG7);

       int check1 = TRUE;
       int check2 = TRUE;
       int check3 = TRUE;
           //current area: Is above ground....      subrace infor says: apply the stats in Underground only or Don't apply it anywhere.
       if(AreaUndAbove == AREA_ABOVEGROUND && !AreaAbove)
       {
          check2 = FALSE;
       }

       if(AreaUndAbove == AREA_UNDERGROUND && !AreaUnd)
       {
         check2 = FALSE;
       }

           //interior
       if(AreaIntExt && !AreaInt)
       {
          check3 = FALSE;
       }
       //exterior
       if(!AreaIntExt && !AreaExt)
       {
          check3 = FALSE;
       }
           //natural
       if(AreaNatArt == AREA_NATURAL && !AreaNat)
       {
           check1 = FALSE;
       }
       if(AreaNatArt == AREA_ARTIFICIAL && !AreaArt)
       {
          check1 = FALSE;
       }
       if(iCurrentTime == TIME_DAY)
       {
           if(iTimeDay && check1 && check2 && check3)
           {
               if(GetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_DAY_STATS_APPLIED))
               { return; }
           }
           if(GetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_DAY_STATS_APPLIED))
           {
              ClearSubraceTemporaryStats(oPC);
              SHA_SendSubraceMessageToPC(oPC, MESSAGE_ABILITY_SCORES_REVERTED, FALSE);
              SetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_DAY_STATS_APPLIED, FALSE);
           }
           if(GetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_NIGHT_STATS_APPLIED))
           {
               ClearSubraceTemporaryStats(oPC);
               SHA_SendSubraceMessageToPC(oPC, MESSAGE_ABILITY_SCORES_REVERTED, FALSE);
               SetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_NIGHT_STATS_APPLIED, FALSE);
           }
       }
       else if(iCurrentTime == TIME_NIGHT)
       {
           if(iTimeNight && check1 && check2 && check3)
           {
               if(GetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_NIGHT_STATS_APPLIED))
               { return; }
           }
           if(GetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_NIGHT_STATS_APPLIED))
           {
               ClearSubraceTemporaryStats(oPC);
               SHA_SendSubraceMessageToPC(oPC, MESSAGE_ABILITY_SCORES_REVERTED, FALSE);
               SetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_NIGHT_STATS_APPLIED, FALSE);
           }
           if(GetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_DAY_STATS_APPLIED))
           {
               ClearSubraceTemporaryStats(oPC);
               SHA_SendSubraceMessageToPC(oPC, MESSAGE_ABILITY_SCORES_REVERTED, FALSE);
               SetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_DAY_STATS_APPLIED, FALSE);
           }
       }

       if((!iTimeNight && iCurrentTime == TIME_NIGHT) && (!iTimeDay && iCurrentTime == TIME_DAY))
       {
            return;
       }
       if(!check1 || !check2 || !check3)
       {
          return;
       }
       int iType = GetLocalInt(oPC, SubraceTag  + IntToString(iCurrentTime) + "_" + SUBRACE_STAT_MODIFIER_TYPE);
       SubraceTag = SubraceTag + IntToString(iCurrentTime);
       if(GetIsResting(oPC))
       {
           AssignCommand(oPC, ClearAllActions(TRUE));
       }

       if(iType == SUBRACE_STAT_MODIFIER_TYPE_PERCENTAGE)
       {
             ApplySubraceBonusStatsByPercentage(oPC, SubraceTag);
       }
       else if(iType == SUBRACE_STAT_MODIFIER_TYPE_POINTS)
       {
            ApplySubraceBonusStatsByPoints(oPC, SubraceTag);
       }
       else
      { return; }
     //STAT MODIFIER TYPE Unrecognised

     TemporaryStatsVisualFX(oPC);
     SHA_SendSubraceMessageToPC(oPC, MESSAGE_ABILITY_SCORES_CHANGED, FALSE);

     if(iCurrentTime == TIME_DAY)
     {
         SetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_DAY_STATS_APPLIED, TRUE);
     }
     else if(iCurrentTime == TIME_NIGHT)
     {
         SetLocalFlag(oPC, SUBRACE_STATS_STATUS, SUBRACE_NIGHT_STATS_APPLIED, TRUE);
     }
}


void ClearSubraceEffects(object oPC)
{
    effect eBad = GetFirstEffect(oPC);
    while(GetIsEffectValid(eBad))
    {
        int iType = GetEffectType(eBad);

        if (iType == EFFECT_TYPE_ARCANE_SPELL_FAILURE ||
            iType == EFFECT_TYPE_BLINDNESS ||
            iType == EFFECT_TYPE_CHARMED ||
            iType == EFFECT_TYPE_CONCEALMENT ||
            iType == EFFECT_TYPE_CONFUSED ||
            iType == EFFECT_TYPE_CUTSCENEGHOST ||
            iType == EFFECT_TYPE_HASTE ||
            iType == EFFECT_TYPE_IMMUNITY ||
            iType == EFFECT_TYPE_IMPROVEDINVISIBILITY ||
            iType == EFFECT_TYPE_INVISIBILITY ||
            iType == EFFECT_TYPE_MISS_CHANCE  ||
            iType == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE  ||
            iType == EFFECT_TYPE_MOVEMENT_SPEED_INCREASE ||
            iType == EFFECT_TYPE_POLYMORPH  ||
            iType == EFFECT_TYPE_REGENERATE ||
            iType == EFFECT_TYPE_SANCTUARY ||
            iType == EFFECT_TYPE_SLOW ||
            iType == EFFECT_TYPE_TEMPORARY_HITPOINTS  ||
            iType == EFFECT_TYPE_TRUESEEING ||
            iType == EFFECT_TYPE_ULTRAVISION  ||
            iType == EFFECT_TYPE_VISUALEFFECT)
          {
              //Remove effect if it is a subracial effect
                if(GetEffectSubType(eBad) == SUBTYPE_SUPERNATURAL)
                {
                    if(GetEffectCreator(eBad) == oPC)
                    {
                        RemoveEffect(oPC, eBad);
                    }
                }
          }
        eBad = GetNextEffect(oPC);
     }
}

void ClearSubraceTemporaryStats(object oPC)
{
    effect eBad = GetFirstEffect(oPC);
    while(GetIsEffectValid(eBad))
    {
        int iType = GetEffectType(eBad);

        if (iType == EFFECT_TYPE_ABILITY_DECREASE ||
            iType == EFFECT_TYPE_ABILITY_INCREASE ||
            iType == EFFECT_TYPE_AC_DECREASE ||
            iType == EFFECT_TYPE_AC_INCREASE ||
            iType == EFFECT_TYPE_ATTACK_INCREASE ||
            iType == EFFECT_TYPE_ATTACK_DECREASE ||
            iType == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
            iType == EFFECT_TYPE_SPELL_RESISTANCE_INCREASE ||
            iType == EFFECT_TYPE_SAVING_THROW_DECREASE)
          {
               //Remove effect if it is a subracial effect
                if(GetEffectSubType(eBad) == SUBTYPE_SUPERNATURAL)
                {
                    if(GetEffectCreator(eBad) == oPC)
                    {
                        RemoveEffect(oPC, eBad);
                    }
                }
          }
        eBad = GetNextEffect(oPC);
     }
}

void ApplySubraceBonusStatsByPoints(object oPC, string SubraceTag)
{
   float strMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER);
   float dexMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER);
   float conMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER);
   float wisMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER);
   float intMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER);
   float chaMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER);

   float ABMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_AB_MODIFIER);
   float ACMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER);

    if(strMod != 0.0)
   {
      ApplyStat_AbilityByPoints(ABILITY_STRENGTH, strMod, oPC);
   }
   if(dexMod !=0.0)
   {
      ApplyStat_AbilityByPoints(ABILITY_DEXTERITY, dexMod, oPC);
   }
   if(conMod != 0.0)
   {
      ApplyStat_AbilityByPoints(ABILITY_CONSTITUTION, conMod, oPC);
   }
   if(wisMod != 0.0)
   {
      ApplyStat_AbilityByPoints(ABILITY_WISDOM, wisMod, oPC);
   }
   if(intMod != 0.0)
   {
      ApplyStat_AbilityByPoints(ABILITY_INTELLIGENCE, intMod, oPC);
   }
   if(chaMod != 0.0)
   {
      ApplyStat_AbilityByPoints(ABILITY_CHARISMA, chaMod, oPC);
   }
   if(ABMod != 0.0)
   {
      ApplyAttackBonusByPoints(ABMod, oPC);
   }
   if(ACMod != 0.0)
   {
     ApplyArmourClassBonusByPoints(ACMod, oPC);
   }
}

void ApplyStat_AbilityByPoints(int AbilityToMod, float points, object oPC)
{
       int StatIncrease = FloatToInt(points);
       effect StatEffect;
       if(StatIncrease > 0)
       {
         StatEffect = EffectAbilityIncrease(AbilityToMod, StatIncrease);
       }
       else if(StatIncrease < 0)
       {
         int StatIncrease1 = abs(StatIncrease);
         StatEffect = EffectAbilityDecrease(AbilityToMod, StatIncrease1);
       }
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
}

void ApplyAttackBonusByPoints(float points, object oPC)
{
   int ABChange = FloatToInt(points);
   effect StatEffect;
   effect StatEffect1;
   if(ABChange > 0)
   {
      StatEffect = EffectAttackIncrease(ABChange, ATTACK_BONUS_ONHAND);
      StatEffect1 = EffectAttackIncrease(ABChange, ATTACK_BONUS_OFFHAND);
   }
   else if(ABChange < 0)
   {
      int ABChange1 = abs(ABChange);
      StatEffect = EffectAttackDecrease(ABChange1, ATTACK_BONUS_ONHAND);
      StatEffect1 = EffectAttackDecrease(ABChange1, ATTACK_BONUS_OFFHAND);
   }
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect1), oPC);
}

void ApplyArmourClassBonusByPoints(float points, object oPC)
{
   int ACChange = FloatToInt(points);
   effect StatEffect;
   if(ACChange > 0)
   {
      StatEffect = EffectACIncrease(ACChange, AC_NATURAL_BONUS);
   }
   else if(ACChange < 0)
   {
     int ACChange1 = abs(ACChange);
     StatEffect = EffectACDecrease(ACChange1, AC_NATURAL_BONUS);
   }
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
}

void ApplySubraceBonusStatsByPercentage(object oPC, string SubraceTag)
{
   float strMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_STR_MODIFIER);
   float dexMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_DEX_MODIFIER);
   float conMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CON_MODIFIER);
   float wisMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_WIS_MODIFIER);
   float intMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_INT_MODIFIER);
   float chaMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_CHA_MODIFIER);

   float ABMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_AB_MODIFIER);
   float ACMod = GetLocalFloat(oPC, SubraceTag + "_" + SUBRACE_STAT_AC_MODIFIER);

   if(strMod != 0.0)
   {
      ApplyStat_AbilityByPercentage(ABILITY_STRENGTH, strMod, oPC);
   }
   if(dexMod !=0.0)
   {
      ApplyStat_AbilityByPercentage(ABILITY_DEXTERITY, dexMod, oPC);
   }
   if(conMod != 0.0)
   {
      ApplyStat_AbilityByPercentage(ABILITY_CONSTITUTION, conMod, oPC);
   }
   if(wisMod != 0.0)
   {
      ApplyStat_AbilityByPercentage(ABILITY_WISDOM, wisMod, oPC);
   }
   if(intMod != 0.0)
   {
      ApplyStat_AbilityByPercentage(ABILITY_INTELLIGENCE, intMod, oPC);
   }
   if(chaMod != 0.0)
   {
      ApplyStat_AbilityByPercentage(ABILITY_CHARISMA, chaMod, oPC);
   }
   if(ABMod != 0.0)
   {
      ApplyAttackBonusByPercentage(ABMod, oPC);
   }
   if(ACMod != 0.0)
   {
     ApplyArmourClassBonusByPercentage(ACMod, oPC);
   }
}

void ApplyStat_AbilityByPercentage(int AbilityToMod, float percentage, object oPC)
{
       int currentStat = GetAbilityScore(oPC, AbilityToMod);
       float cStat = IntToFloat(currentStat);

       float Stat = cStat*percentage;
       int newStat = FloatToInt(Stat);
       effect StatEffect;
       if(newStat > 0)
       {
         StatEffect = EffectAbilityIncrease(AbilityToMod, newStat);
       }
       else if(newStat < 0)
       {
         int newStat1 = abs(newStat);
         StatEffect = EffectAbilityDecrease(AbilityToMod, newStat1);
       }
       ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
}

void ApplyAttackBonusByPercentage(float percentage, object oPC)
{
   float currentAB = IntToFloat(GetBaseAttackBonus(oPC));
   int Neg = FALSE;
   int Neg2 = FALSE;
   if(currentAB < 0.0 )
   { Neg = TRUE; }
   if(percentage < 0.0 )
   { Neg2 = TRUE; }
   int newAB = FloatToInt(currentAB*percentage);
   if(Neg && Neg2 )
   { newAB = -newAB; }
   effect StatEffect;
   effect StatEffect1;
   if(newAB > 0)
   {
      StatEffect = EffectAttackIncrease(newAB, ATTACK_BONUS_ONHAND);
      StatEffect1 = EffectAttackIncrease(newAB, ATTACK_BONUS_OFFHAND);
   }
   else if(newAB < 0)
   {
      int newAB1 = abs(newAB);
      StatEffect = EffectAttackDecrease(newAB1, ATTACK_BONUS_ONHAND);
      StatEffect1 = EffectAttackDecrease(newAB1, ATTACK_BONUS_OFFHAND);
   }
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect1), oPC);
}

void ApplyArmourClassBonusByPercentage(float percentage, object oPC)
{
   float currentAC =  IntToFloat(GetAC(oPC));
   int newAC = FloatToInt(currentAC*percentage);
   effect StatEffect;
   if(newAC > 0)
   {
      StatEffect = EffectACIncrease(newAC, AC_NATURAL_BONUS, AC_VS_DAMAGE_TYPE_ALL);
   }
   else if(newAC < 0)
   {
     int newAC1 = abs(newAC);
     StatEffect = EffectACDecrease(newAC1, AC_NATURAL_BONUS, AC_VS_DAMAGE_TYPE_ALL);
   }
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(StatEffect), oPC);
}



void SHA_SubraceForceUnequipItem(object oItem)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), OBJECT_SELF, 0.1);
    ClearAllActions(TRUE);
    ActionUnequipItem(oItem);
    ActionDoCommand(SetCommandable(TRUE));
    SetCommandable(FALSE);
}

void SHA_SubraceForceEquipItem(object oItem, int InvoSlot)
{
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), OBJECT_SELF, 0.1);
    ClearAllActions(TRUE);
    ActionEquipItem(oItem, InvoSlot);
    ActionDoCommand(SetCommandable(TRUE));
    SetCommandable(FALSE);
}
string Subrace_WeaponRestrictionToString(int ResType)
{
   string ret = "";
   switch(ResType)
   {
      case SUBRACE_RESTRICTION_WEAPON_MELEE:   ret = "Melee Weapons"; break;
      case SUBRACE_RESTRICTION_WEAPON_RANGED:  ret = "Ranged Weapons"; break;
      case SUBRACE_RESTRICTION_WEAPON_TINY:  ret = "Tiny Weapons"; break;
      case SUBRACE_RESTRICTION_WEAPON_LARGE:  ret = "Large Weapons"; break;
      case SUBRACE_RESTRICTION_WEAPON_SIMPLE: ret = "Simple Weapons"; break;
      case SUBRACE_RESTRICTION_WEAPON_MARTIAL: ret = "Martial Weapons"; break;
      case SUBRACE_RESTRICTION_WEAPON_EXOTIC:  ret = "Exotic Weapons"; break;
      case SUBRACE_RESTRICTION_WEAPON_ALL:  ret = "All types of Weapons"; break;
      default:  ret = "ERROR"; break;
   }
   return ret;
}


string Subrace_DefenseRestrictionToString(int ResType)
{
   string ret = "";
   switch(ResType)
   {
      case SUBRACE_RESTRICTION_DEFENSE_CLOTHING:   ret = "Clothing"; break;
      case SUBRACE_RESTRICTION_DEFENSE_HEAVY:  ret = "Heavy Defense"; break;
      case SUBRACE_RESTRICTION_DEFENSE_LIGHT:  ret = "Light Defense"; break;
      case SUBRACE_RESTRICTION_DEFENSE_MEDIUM:  ret = "Medium Weapons"; break;
      case SUBRACE_RESTRICTION_DEFENSE_ALL: ret = "All Defenses"; break;
      default:  ret = "ERROR"; break;
   }
   return ret;
}
void CheckCanUseWeapon(object oItem, object oPC, string SubraceTag)
{
   int HasRes = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_HAS_RESTRICTION, SUBRACE_RESTRICTION_FLAGS);
   if(HasRes)
   {

      int ResType = GetLocalGroupFlagValue(oPC, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_RESTRICTION_WEAPON);
      int ResTime = GetLocalGroupFlagValue(oPC, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, TIME_FLAGS);
      int Allow = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_ALLOW_ONLY_THIS_TYPE, SUBRACE_RESTRICTION_FLAGS);

       //First make sure it is a weapon...
       if(!SHA_GetIsRangedWeapon(oItem) && !SHA_GetIsMeleeWeapon(oItem))
       {
            return;
       }

       int iResult = 100;
       if(ResTime == TIME_NIGHT)
       {
           if(!GetIsNight() && !GetIsDusk())
           { return; }
       }
       else if(ResTime == TIME_DAY)
       {
          if(!GetIsDay() && !GetIsDawn())
           { return; }
       }

       switch(ResType)
       {
          case SUBRACE_RESTRICTION_WEAPON_MELEE:   iResult = SHA_GetIsMeleeWeapon(oItem); break;
          case SUBRACE_RESTRICTION_WEAPON_RANGED:  iResult = SHA_GetIsRangedWeapon(oItem); break;
          case SUBRACE_RESTRICTION_WEAPON_TINY:  iResult = SHA_GetIsWeaponTiny(oItem); break;
          case SUBRACE_RESTRICTION_WEAPON_LARGE:  iResult = SHA_GetIsWeaponLarge(oItem); break;
          case SUBRACE_RESTRICTION_WEAPON_SIMPLE: iResult = SHA_GetIsSimpleWeapon(oItem); break;
          case SUBRACE_RESTRICTION_WEAPON_MARTIAL: iResult = SHA_GetIsMartialWeapon(oItem); break;
          case SUBRACE_RESTRICTION_WEAPON_EXOTIC:  iResult = SHA_GetIsExoticWeapon(oItem); break;
          case SUBRACE_RESTRICTION_WEAPON_ALL:  iResult = TRUE;
          default:  iResult = FALSE;
       }
      //It is the type of weapon the sub-race is restricted against.
       if(iResult && !Allow)
       {
          iResult = FALSE;
       }
       else if(!iResult && !Allow)
       {
          iResult = TRUE;
       }

       if(!iResult)
       {
          SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CANNOT_EQUIP_WEAPON, TRUE);
          DelayCommand(0.3, AssignCommand(oPC, SHA_SubraceForceUnequipItem(oItem)));
       }
   }
}

void CheckCanUseArmor(object oItem, object oPC, string SubraceTag)
{
   int HasRes = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, SUBRACE_HAS_RESTRICTION, SUBRACE_RESTRICTION_FLAGS);

   if(HasRes)
   {
       int ResType = GetLocalGroupFlagValue(oPC, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, SUBRACE_RESTRICTION_DEFENSE);
       int ResTime = GetLocalGroupFlagValue(oPC, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, TIME_FLAGS);
       int Allow = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_ARMOUR_RESTRICTION, SUBRACE_ALLOW_ONLY_THIS_TYPE, SUBRACE_RESTRICTION_FLAGS);

       int iCheck = FALSE;
       int iType = GetBaseItemType(oItem);

       if(iType == BASE_ITEM_ARMOR || iType == BASE_ITEM_LARGESHIELD || iType == BASE_ITEM_TOWERSHIELD || iType == BASE_ITEM_SMALLSHIELD || iType == BASE_ITEM_HELMET)
       {
         iCheck = TRUE;
       }
       if(iCheck)
       {
          int iResult = 100;
          if(ResTime == TIME_NIGHT)
          {
               if(!GetIsNight() && !GetIsDusk())
               { return; }
          }
          else if(ResTime == TIME_DAY)
          {
              if(!GetIsDay() && !GetIsDawn())
               { return; }
          }

          int BaseAC = GetArmorType(oItem);

          if(ResType == SUBRACE_RESTRICTION_DEFENSE_HEAVY)
          {
               if(BaseAC >= 7 || iType == BASE_ITEM_TOWERSHIELD || iType == BASE_ITEM_HELMET)
               {
                  iResult = TRUE;
               }
               else
               {
                   iResult = FALSE;
               }
          }
          else if(ResType == SUBRACE_RESTRICTION_DEFENSE_MEDIUM)
          {
               if((BaseAC >= 4 && BaseAC < 7) || iType == BASE_ITEM_LARGESHIELD || iType == BASE_ITEM_HELMET)
               {
                  iResult = TRUE;
               }
               else
               {
                   iResult = FALSE;
               }
          }
          else if(ResType == SUBRACE_RESTRICTION_DEFENSE_LIGHT)
          {
               if((BaseAC >= 1 && BaseAC < 4) || iType == BASE_ITEM_SMALLSHIELD)
               {
                  iResult = TRUE;
               }
               else
               {
                   iResult = FALSE;
               }
          }
          else if(ResType == SUBRACE_RESTRICTION_DEFENSE_CLOTHING)
          {
               if(BaseAC == 0 && iType != BASE_ITEM_LARGESHIELD && iType != BASE_ITEM_TOWERSHIELD && iType != BASE_ITEM_SMALLSHIELD  && iType != BASE_ITEM_HELMET)
               {
                  iResult = TRUE;
               }
               else
               {
                   iResult = FALSE;
               }
          }
          else if(ResType == SUBRACE_RESTRICTION_DEFENSE_ALL)
          {
             iResult = TRUE;
          }

          if(iResult && !Allow)
          {
               iResult = FALSE;
          }
          else if(!iResult && !Allow)
          {
                iResult = TRUE;
          }

          if(!iResult)
          {
              SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_CANNOT_EQUIP_ARMOR, TRUE);
              DelayCommand(0.3, AssignCommand(oPC, SHA_SubraceForceUnequipItem(oItem)));
          }
       }
    }
}
void CheckCanUseItem(object oItem, object oPC)
{
   string subrace = GetStringLowerCase(GetSubRace(oPC));
   if(subrace == "")
   { return; }
   string SubraceTag = SUBRACE_TAG + "_" + subrace;
   CheckCanUseArmor(oItem, oPC, SubraceTag);
   CheckCanUseWeapon(oItem, oPC, SubraceTag);
}
void SubraceOnPlayerEquipItem()
{
   object oItem = GetPCItemLastEquipped();
   object oPC = GetPCItemLastEquippedBy();
   CheckCanUseItem(oItem, oPC);
}

void CheckIfCanUseEquipedWeapon(object oPC)
{
    string subrace = GetStringLowerCase(GetSubRace(oPC));
    if(subrace == "")
    { return; }

    string SubraceTag = SUBRACE_TAG + "_" + subrace;
    int HasRes = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_WEAPON_RESTRICTION, SUBRACE_HAS_RESTRICTION, SUBRACE_RESTRICTION_FLAGS);
    if(!HasRes)
    { return; }
    object Wep1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object Wep2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    CheckCanUseItem(Wep1, oPC);
    DelayCommand(3.0, CheckCanUseItem(Wep2, oPC));
}

void CheckIfCanUseEquippedArmor(object oPC)
{
    string subrace = GetStringLowerCase(GetSubRace(oPC));
    if(subrace == "")
    { return; }

   string SubraceTag = SUBRACE_TAG + "_" + subrace;
   object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
   CheckCanUseArmor(oItem, oPC, SubraceTag);
}

void InitiateSubraceChecking(object oPC)
{
    string subrace = GetStringLowerCase(GetSubRace(oPC));

    if(subrace != "")
    {
        int check1 = GetSubraceDBInt(SUBRACE_DATABASE, SUBRACE_TAG + "_" + subrace, oPC);

        if(check1 == SUBRACE_UNINITIALIZED)
        {
           int check2 = CheckIfPCMeetsAnySubraceCriteria(oPC);
           if(check2 == SUBRACE_UNRECOGNISED)
           {
              return;
           }
           else if(!check2)
           {

            SetSubraceDBInt(SUBRACE_DATABASE, SUBRACE_TAG + "_" + subrace, SUBRACE_REJECTED, oPC);


              return;
           }
           else if(check2)
           {

              SetSubraceDBInt(SUBRACE_DATABASE, SUBRACE_TAG + "_" + subrace, SUBRACE_ACCEPTED, oPC);
           }
       }
       else if(check1 == SUBRACE_ACCEPTED)
       {
       }
       else if(check1 == SUBRACE_REJECTED)
       {
          //SUBRACE was rejected previously.
          return;
       }
       if(SEARCH_AND_DESTROY_SKINS_IN_INVENTORY)
       {
            SearchAndDestroySkinsAndClaws(oPC);
       }

       DelayCommand(1.0, LoadSubraceInfoOnPC(oPC, subrace));
       DelayCommand(2.0, ApplyPermanentSubraceSpellResistance(subrace, oPC));
       DelayCommand(3.0, ApplyPermanentSubraceAppearance(subrace, oPC));
       DelayCommand(20.0, ChangeSubraceFactions(oPC, subrace));
       DelayCommand(21.0, Subrace_MoveToStartLocation(oPC, subrace));
   }
}

void Subrace_MoveToStartLocation(object oPC, string subrace)
{
  string SubraceTag =  SUBRACE_TAG + "_" + subrace;
  string WPTag = GetLocalString(oStorer, SubraceTag + "_" + SUBRACE_START_LOCATION);
  object oWP = GetWaypointByTag(WPTag);
  if(oWP != OBJECT_INVALID)
  {
     DelayCommand(0.5, AssignCommand(oPC, JumpToLocation(GetLocation(oWP))));
     DelayCommand(0.5, SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_MOVE_TO_START_LOCATION1 + CapitalizeString(subrace) + MESSAGE_SUBRACE_MOVE_TO_START_LOCATION2));
  }
}

void ChangeSubraceFactions(object oPC, string subrace)
{
   string SubraceTag = SUBRACE_TAG + "_" + subrace;
   int Count =  GetLocalInt(oPC, SubraceTag + "_" + SUBRACE_FACTION_COUNT);
   if(Count != 0)
   {
        float fDelay;
        while(Count != 0)
        {
            fDelay += 0.10;
            string  FactionCreatureTag = GetLocalString(oPC, SubraceTag + "_" + SUBRACE_FACTION_CREATURE + "_" + IntToString(Count));
            int Reputation = GetLocalInt(oPC, SubraceTag + "_" + SUBRACE_FACTION_REPUTATION + "_" + IntToString(Count));
            DelayCommand(fDelay, Subrace_FactionAdjustment(oPC, FactionCreatureTag, Reputation));
            Count--;
        }
        SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_FACTION_ADJUSTED, FALSE);
    }

}

void Subrace_FactionAdjustment(object oPC, string FactionTag, int Adjustment)
{
   object Faction = GetObjectByTag(FactionTag);
   if(Faction != OBJECT_INVALID)
   {
      ClearPersonalReputation(oPC, Faction);
      ClearPersonalReputation(Faction, oPC);
      //Make friendly first..
      AdjustReputation(oPC, Faction, 100);

      //Now adjust
      AdjustReputation(oPC, Faction, Adjustment);
   }

}
void CheckAndSwitchSubrace(object oPC)
{
   string subrace = GetStringLowerCase(GetSubRace(oPC));
   if(subrace == "")
   { return; }
   string SubraceTag = SUBRACE_TAG + "_" + subrace;
   int Level = GetPlayerLevel(oPC);
   int End = FALSE;
   string switchSubraceNames = GetLocalString(oPC, SubraceTag + "_" + SUBRACE_SWITCH_NAME + IntToString(Level));
   if(switchSubraceNames != "")
   {
       while(switchSubraceNames != "")
       {
           int iPos = FindSubString(switchSubraceNames, "_");
           string sSubrace;
           if(iPos != -1)
           {
              sSubrace = GetStringLeft(switchSubraceNames, iPos);
           }
           else
           {
              sSubrace = switchSubraceNames;
              End = TRUE;
           }
           switchSubraceNames = GetStringRight(switchSubraceNames, GetStringLength(switchSubraceNames) - iPos - 1);
           string CurrentSubrace = GetSubRace(oPC);
           string NewSubrace = CapitalizeString(sSubrace);
           SetSubRace(oPC, NewSubrace);
           subrace = GetStringLowerCase(GetSubRace(oPC));
           SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_SWITCH_CHECKING_REQUIREMENTS1 + NewSubrace + MESSAGE_SUBRACE_SWITCH_CHECKING_REQUIREMENTS2, TRUE);
           int check = TRUE;
           int NeedToMeetRequirements = GetLocalInt(oPC, SubraceTag + "_" + SUBRACE_SWITCH_MUST_MEET_REQUIREMENTS + IntToString(Level));
          //only check restrictions if need be.
           if(NeedToMeetRequirements)
           {
               check = CheckIfPCMeetsAnySubraceCriteria(oPC);
           }
           if(check == SUBRACE_UNRECOGNISED)
           {
              return;
           }
           else if(!check)
           {
              SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_FAILED_REQUIREMENTS_ALIGNMENT_FOR_SWITCH + NewSubrace + MESSAGE_SUBRACE_SWITCH_CHECKING_REQUIREMENTS2, TRUE);
              SetSubRace(oPC, CurrentSubrace);
              if(End == TRUE)
              { return; }
           }
           else if(check)
           {
               SetSubraceDBInt(SUBRACE_DATABASE, SUBRACE_TAG + "_" + subrace, SUBRACE_ACCEPTED, oPC);

               //revert it back to delete the stored info.
               SetSubRace(oPC, CurrentSubrace);
               DeleteSubraceInfoOnPC(oPC);
               subrace = GetStringLowerCase(NewSubrace);
               DelayCommand(4.2, SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_SWITCHING + NewSubrace + "...", TRUE));
               DelayCommand(4.3, SetSubRace(oPC, NewSubrace));
               DelayCommand(5.1, LoadSubraceInfoOnPC(oPC, subrace));
               DelayCommand(7.0, ApplyPermanentSubraceSpellResistance(subrace, oPC));
               DelayCommand(8.5, ApplyPermanentSubraceAppearance(subrace, oPC));
               DelayCommand(15.0, CheckIfCanUseEquipedWeapon(oPC));
               DelayCommand(18.5, CheckIfCanUseEquippedArmor(oPC));
               DelayCommand(21.5, SHA_SendSubraceMessageToPC(oPC, MESSAGE_SUBRACE_SWITCHED, TRUE));
               return;
           }
       }
   }
}


void SubraceOnPlayerLevelUp()
{
    object oPC = GetPCLevellingUp();
    int Level = GetPlayerLevel(oPC);
    ReapplySubraceAbilities(oPC);
    DelayCommand(2.0, CheckAndGiveSubraceItems(oPC));
    int NeedsToRelog = CheckForLetoReLog(oPC, Level);
    if(NeedsToRelog)
    {
       if(!LETO_ACTIVATE_PORTAL)
       {
           DelayCommand(5.0, PopUpDeathGUIPanel(oPC, FALSE, FALSE, 0, SUBRACE_ENGINE + MESSAGE_LETO_PLEASE_RELOG));
           if(LETO_AUTOMATICALLY_BOOT)
           {
               DelayCommand(5.2, SHA_SendSubraceMessageToPC(oPC, MESSAGE_LETO_AUTOBOOT1 + IntToString(LETO_AUTOMATIC_BOOT_DELAY) + MESSAGE_LETO_AUTOBOOT2));
               DelayCommand(5.2 + IntToFloat(LETO_AUTOMATIC_BOOT_DELAY), DelayBoot(oPC));
           }
       }
       else
       {
              if(!LETO_PORTAL_KEEP_CHARACTER_IN_THE_SAME_PLACE)
              {
                  DelayCommand(5.2, SHA_SendSubraceMessageToPC(oPC, MESSAGE_LETO_AUTOPORTAL + IntToString(LETO_AUTOMATIC_PORTAL_DELAY) + MESSAGE_LETO_AUTOBOOT2));
                  DelayCommand(5.2 + IntToFloat(LETO_AUTOMATIC_PORTAL_DELAY), ActivatePortal(oPC, LETO_PORTAL_IP_ADDRESS, LETO_PORAL_SERVER_PASSWORD, LETO_PORTAL_WAYPOINT, TRUE));
              }
              else
              {
                   int RandomNumber = d100(1);
                   object oWaypoint = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint001", GetLocation(oPC), FALSE, "WP_SUBRACE_P" + IntToString(RandomNumber));
                   string sWPTag = "WP_SUBRACE_P" + IntToString(RandomNumber);
                   DelayCommand(5.2, SHA_SendSubraceMessageToPC(oPC, MESSAGE_LETO_DONT_PANIC_JUSTPORTING));
                   DelayCommand(5.0, ActivatePortal(oPC, LETO_PORTAL_IP_ADDRESS, LETO_PORAL_SERVER_PASSWORD, sWPTag, TRUE));
                   DelayCommand(15.0, DestroyObject(oWaypoint, 0.1));
              }
       }

       DelayCommand(5.0, SetSubraceDBInt(SUBRACE_DATABASE, SUBRACE_TAG + LETO_CHANGES_MADE_FOR_THIS_LEVEL, Level, oPC));
    }
    else
    {
       DelayCommand(6.0, CheckAndSwitchSubrace(oPC));
    }
}

//LETO FUNCTIONS
int CheckForLetoReLog(object oPC, int Level)
{
   if(!ENABLE_LETO)
   { return FALSE; }

   string subrace = GetStringLowerCase(GetSubRace(oPC));
   string SubraceTag = SUBRACE_TAG + "_" + subrace;
   int LetoChanges = GetSubraceDBInt(SUBRACE_DATABASE, SUBRACE_TAG + LETO_CHANGES_MADE_FOR_THIS_LEVEL, oPC);

   if(LetoChanges >= Level)
   { return FALSE; }

   int NeedsToRelog = FALSE;
   string SubraceTag1 = SubraceTag + "_" + IntToString(Level);

   if(GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS) != 0)
   {
      NeedsToRelog = TRUE;
   }
   else if(GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_HAS_BASE_STAT_MODIFIERS))
   {
      NeedsToRelog = TRUE;
   }
   else if(GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_FEAT_COUNT) > 0)
   {
      NeedsToRelog = TRUE;
   }
   else if(GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_SOUNDSET_FLAGS) != 0)
   {
      NeedsToRelog = TRUE;
   }
   else if(GetLocalString(oPC, SubraceTag1 + "_" + SUBRACE_PORTRAIT) != "")
   {
      NeedsToRelog = TRUE;
   }
   else if(GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_SKILL_COUNT) > 0)
   {
      NeedsToRelog = TRUE;
   }
   SetLocalInt(oPC, "SUBRACE_NEEDS_TO_RELOG", NeedsToRelog);
   return NeedsToRelog;
}

string LetoSubraceModifications(object oPC, string SubraceTag, int Level)
{
  string ScriptForLeto = "";
  ScriptForLeto += CheckAndModifyAttachments(oPC, SubraceTag, Level);
  ScriptForLeto += CheckAndModifyBaseStats(oPC, SubraceTag, Level);
  ScriptForLeto += CheckAndModifyFeats(oPC, SubraceTag, Level);
  ScriptForLeto += CheckAndModifySoundSet(oPC, SubraceTag, Level);
  ScriptForLeto += CheckAndModifyPortrait(oPC, SubraceTag, Level);
  ScriptForLeto += CheckAndModifySkills(oPC, SubraceTag, Level);
  //ScriptForLeto += LETO_ModifyHitPoints(100);
  //ScriptForLeto += SetDocumentedLevel();
  //ScriptForLeto += LETO_SetBicTag(BicFile);
  //PrintString(ScriptForLeto);
  return  ScriptForLeto;
}

void SubraceOnClientLeave()
{
   object oPC = GetExitingObject();
   string BicFile = LETO_GetBicPath(oPC);

   // if(!GetIsPC(oPC))
   // { return; }

   string subrace = GetStringLowerCase(GetSubRace(oPC));
   if(subrace == "")
   {  return; }

   if(!ENABLE_LETO)
   {  return; }

   int Level = GetPlayerLevel(oPC);

   int LetoChanges = GetLocalInt(oPC, "SUBRACE_NEEDS_TO_RELOG");
   if(LetoChanges)
   {
       string SubraceTag = SUBRACE_TAG + "_" + subrace;

       string ScriptForLeto = LetoSubraceModifications(oPC, SubraceTag, Level);

       WriteTimestampedLogEntry("*Subrace Engine LETOScript call for " + GetName(oPC) + " | " + GetLocalString(oPC, "SUBR_PlayerName") + " | " + BicFile + "* ");
       string LetoError = LetoScript("%char= q!"+BicFile+"!; "+ScriptForLeto+"%char = '>'; close %char; ");
       if(LetoError != "")
       {
          WriteTimestampedLogEntry("*Subrace Engine LETOScript Error: " + LetoError + "*");
       }
   }
}


string CheckAndModifyAttachments(object oPC, string SubraceTag, int Level)
{
   string script = "";
   string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
   if(GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS) != 0)
   {
       int Wings = GetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, SUBRACE_ATTACHMENT_FLAGS_WINGS);
       int Tail = GetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + SUBRACE_ATTACHMENT_FLAGS, SUBRACE_ATTACHMENT_FLAGS_TAIL);
       script += LETO_ModifyWings(Wings);
       script += LETO_ModifyTail(Tail);
   }
   return script;
}

string CheckAndModifyBaseStats(object oPC, string SubraceTag, int Level)
{
   string script = "";
   string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
   int HasBMods = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_HAS_BASE_STAT_MODIFIERS);
   if(HasBMods)
   {
       int StrengthModifier = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_STR_MODIFIER);
       int DexterityModifier = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_DEX_MODIFIER);
       int ConstitutionModifier =  GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_CON_MODIFIER);
       int IntelligenceModifier =  GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_INT_MODIFIER);
       int WisdomModifier =  GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_WIS_MODIFIER);
       int CharismaModifier =  GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_CHA_MODIFIER);
       int SpdModifier =   GetLocalInt(oPC, SubraceTag1  + "_" + SUBRACE_BASE_STAT_SPD_MODIFIER);
       //int HPModifier =   GetLocalInt(oPC, SubraceTag1  + "_" + SUBRACE_BASE_STAT_HP_MODIFIER);
       int Set = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BASE_STAT_MODIFIERS_REPLACE);


       script += LETO_ModifyProperty("Str", StrengthModifier, Set);
       script += LETO_ModifyProperty("Dex", DexterityModifier, Set);
       script += LETO_ModifyProperty("Con", ConstitutionModifier, Set);
       script += LETO_ModifyProperty("Wis", WisdomModifier, Set);
       script += LETO_ModifyProperty("Int", IntelligenceModifier, Set);
       script += LETO_ModifyProperty("Cha", CharismaModifier, Set);

       script += LETO_SetMovementSpeed(SpdModifier);
       //script += LETO_ModifyHitPoints(HPModifier, Set);
   }
   return script;
}

string CheckAndModifyFeats(object oPC, string SubraceTag, int Level)
{
   string script = "";
   string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
   int FeatCount = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_FEAT_COUNT);
   if(FeatCount > 0)
   {
      while(FeatCount != 0)
      {
         int Feat = GetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS, SUBRACE_BONUS_FEAT_FLAG);
         int Remove = GetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + IntToString(FeatCount) + "_" + SUBRACE_BONUS_FEAT_FLAGS, SUBRACE_BONUS_FEAT_REMOVE_FLAG);
         FeatCount--;
         script += LETO_ModifyFeat(Feat, Remove);
      }

   }
   return script;
}

string CheckAndModifySkills(object oPC, string SubraceTag, int Level)
{
   string script = "";
   string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
   int SkillCount = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_BONUS_SKILL_COUNT);
   if(SkillCount > 0)
   {
      while(SkillCount != 0)
      {
         int Skill = GetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SUBRACE_BONUS_SKILL_FLAG);
         int Remove = GetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SUBRACE_BONUS_SKILL_REMOVE_FLAG);
         int Mod = GetLocalGroupFlagValue(oPC, SubraceTag1 + "_" + IntToString(SkillCount) + "_" + SUBRACE_BONUS_SKILL_FLAGS, SUBRACE_BONUS_SKILL_MODIFIER_FLAG);
         SkillCount--;
         script += LETO_ModifySkill(Skill, Mod, Remove);
      }

   }
   return script;
}

string CheckAndModifyPortrait(object oPC, string SubraceTag, int Level)
{
  string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
  string Portrait = GetLocalString(oPC, SubraceTag1 + "_" + SUBRACE_PORTRAIT);
  if(Portrait != "")
  {
      return LETO_ModifyPortrait(Portrait);
  }
  return "";
}

string CheckAndModifySoundSet(object oPC, string SubraceTag, int Level)
{
   string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
   int SoundSet = GetLocalInt(oPC, SubraceTag1 + "_" + SUBRACE_SOUNDSET_FLAGS);
   if(SoundSet != 0)
   {
      return LETO_SetSoundSet(SoundSet);
   }
   return "";
}


void SubraceOnPlayerRespawn()
{
    object oPC = GetLastRespawnButtonPresser();
    ReapplySubraceAbilities(oPC);
    DelayCommand(2.0, ChangeSubraceFactions(oPC, GetStringLowerCase(GetSubRace(oPC))));
}
void ReapplySubraceAbilities(object oPC)
{
     string subrace = GetStringLowerCase(GetSubRace(oPC));

     if(subrace == "")
     { return; }
     SetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC, FALSE);
     DeleteLocalInt(oPC, SUBRACE_TAG + "SB_NITE_OCE");
     DeleteLocalInt(oPC, SUBRACE_TAG + "SB_DAY_OCE");
     DeleteLocalInt(oPC, APPEARANCE_TEMP_CHANGED);
     DeleteLocalInt(oPC, SUBRACE_IN_SPELL_DARKNESS);
     DeleteLocalInt(oPC, "SUB_EFCT_D_APD");
     DeleteLocalInt(oPC, "SUB_EFCT_N_APD");
     string SubraceTag = SUBRACE_TAG + "_" + subrace;
     int IsLightSens = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
     int IsUndergSens = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
     if(IsLightSens)
     {
        DeleteLocalInt(oPC,"SB_LGHT_DMGED");
     }
     if(IsUndergSens)
     {
         DeleteLocalInt(oPC,"SB_DARK_DMGED");
     }
     ApplyPermanentSubraceSpellResistance(subrace, oPC);
     int HasDiffStats = GetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG1);
     if(HasDiffStats)
     {
        DeleteLocalInt(oPC, SUBRACE_STATS_STATUS);
        ClearSubraceTemporaryStats(oPC);
     }
     DelayCommand(2.0, ApplyPermanentSubraceAppearance(subrace, oPC));
     DelayCommand(3.0, SearchAndDestroySkinsAndClaws(oPC));
     DelayCommand(4.0, SetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC, TRUE));
}

int SHA_GetCurrentTime()
{
   if(GetIsNight() || GetIsDusk())
   {
       return TIME_NIGHT;
   }
   return TIME_DAY;
}

void SwapAppearance(object oPC, string subrace)
{
   string SubraceTag = SUBRACE_TAG + "_" + subrace;
   int Level = GetPlayerLevel(oPC);
   while(Level != 0)
   {
       string SubraceTag1 = SubraceTag + "_" + IntToString(Level);
       int iTime = GetLocalGroupFlagValue(oStorer, SubraceTag1 + "_" + APPEARANCE_CHANGE, TIME_FLAGS);
       if(iTime != 0)
       {
           if(SHA_GetDefaultAppearanceType(oPC) == GetAppearanceType(oPC))
           {
               ChangePCAppearance(oPC, SubraceTag1);
           }
           else
           {
              ChangeToPCDefaultAppearance(oPC);
           }
           return;
       }
       Level--;
   }
}
void SubraceCheckItemActivated(object oPC, object oItem)
{
   string subrace = GetStringLowerCase(GetSubRace(oPC));
   if(subrace == "")
   { return; }
   string sTag = GetStringLowerCase(GetTag(oItem));
   if(subrace == sTag)
   {
      SwapAppearance(oPC, subrace);
   }

}

void SubraceOnItemActivated()
{
   object oPC =  GetItemActivator();
   object oItem = GetItemActivated();
   SubraceCheckItemActivated(oPC, oItem);
}

void SubraceOnClientEnter()
{
   object oPC = GetEnteringObject();
   if(!GetIsPC(oPC))
   { return; }
   int infoLoaded = GetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC);
   if(!infoLoaded)
   {
      SetLocalString(oPC, "SUBR_PlayerName", GetPCPlayerName(oPC));

      string subrace = GetStringLowerCase(GetSubRace(oPC));
      if(subrace == "")
      { return; }
      DelayCommand(1.0, InitiateSubraceChecking(oPC));
   }
   else
   {
      ReapplySubraceAbilities(oPC);
      DeleteLocalInt(oPC, "SUBRACE_NEEDS_TO_RELOG");
   }
}


//Subrace Default Heartbeat. (For use in default.nss)
void SubraceHeartbeat(object oPC = OBJECT_SELF)
{
    if(!GetLocalInt(oPC, SUBRACE_INFO_LOADED_ON_PC))
    { return; }
    string subrace = GetLocalString(oPC, SUBRACE_TAG);
    if(subrace == "")
    { return; }

    string SubraceTag = SUBRACE_TAG + "_" + subrace;

    int IsDay = GetIsDay();
    int IsDawn = GetIsDawn();

    int IsNight = GetIsNight();
    int IsDusk = GetIsDusk();

    object oArea = GetArea(oPC);
    int AreaLocation = GetIsAreaAboveGround(oArea);
    int Interior = GetIsAreaInterior(oArea);
    int Natural = GetIsAreaNatural(oArea);

    //string oAreaTag = GetTag(oArea);

    int HasDiffStats = GetLocalFlag(oPC, SubraceTag + "_" + SUBRACE_STAT_MODIFIERS, FLAG1);

    if(IsDay || IsDawn)
    {
       if(AreaLocation == AREA_ABOVEGROUND && !Interior)
       {
          int IsLightSens = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_LIGHT_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
          int DmgTakenL = GetLocalInt(oPC, SubraceTag + "_" + DAMAGE_AMOUNT_IN_LIGHT);
          if(IsLightSens)
          {
              ApplyLightSensitivity(oPC);
          }
          if(DmgTakenL != 0)
          {
              ApplyDamageWhileInLight(oPC, DmgTakenL);
          }
        }
       if(AreaLocation == AREA_UNDERGROUND)
       {
          int IsUndergSens = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
          int DmgTakenU = GetLocalInt(oPC, SubraceTag + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND);
          if(IsUndergSens)
          {
             ApplyUndergroundSensitivity(oPC);
          }
          if(DmgTakenU != 0)
          {
            ApplyDamageWhileInDark(oPC, DmgTakenU);
          }
       }
       if(HasDiffStats)
       {
           ApplyTemporarySubraceStats(oPC, SubraceTag, TIME_DAY, AreaLocation, Interior, Natural);
       }
       if(!GetLocalInt(oPC, SUBRACE_TAG + "SB_DAY_OCE"))
       {
           ApplyTemporarySubraceAppearance(SubraceTag, oPC, TIME_DAY);
           ApplySubraceEffect(oPC, SubraceTag, TIME_DAY);
           CheckIfCanUseEquipedWeapon(oPC);
           DelayCommand(2.0, EquipTemporarySubraceSkin(SubraceTag, oPC, TIME_DAY));
           DelayCommand(6.0, EquipTemporarySubraceClaw(SubraceTag, oPC, TIME_DAY));
           SetLocalInt(oPC, SUBRACE_TAG + "SB_DAY_OCE", TRUE);
           DeleteLocalInt(oPC, SUBRACE_TAG + "SB_NITE_OCE");
       }
    }
    else if(IsNight || IsDusk)
    {
      if(AreaLocation == AREA_UNDERGROUND)
      {
          int IsUndergSens = GetLocalGroupFlag(oPC, SubraceTag + "_" + SUBRACE_BASE_INFORMATION, SUBRACE_BASE_INFORMATION_UNDERGROUND_SENSITIVE, SUBRACE_BASE_INFORMATION_FLAGS);
          int DmgTakenU = GetLocalInt(oPC, SubraceTag + "_" + DAMAGE_AMOUNT_IN_UNDERGROUND);
          if(IsUndergSens)
          {
             ApplyUndergroundSensitivity(oPC);
          }
          if(DmgTakenU > 0)
          {
             ApplyDamageWhileInDark(oPC, DmgTakenU);
          }
       }
       if(HasDiffStats)
       {
           ApplyTemporarySubraceStats(oPC, SubraceTag, TIME_NIGHT, AreaLocation, Interior, Natural);
       }
       if(!GetLocalInt(oPC, SUBRACE_TAG + "SB_NITE_OCE"))
       {
           ApplyTemporarySubraceAppearance(SubraceTag, oPC, TIME_NIGHT);

           ApplySubraceEffect(oPC, SubraceTag, TIME_NIGHT);
           CheckIfCanUseEquipedWeapon(oPC);
           DelayCommand(2.0, EquipTemporarySubraceSkin(SubraceTag, oPC, TIME_NIGHT));
           DelayCommand(6.0, EquipTemporarySubraceClaw(SubraceTag, oPC, TIME_NIGHT));
           SetLocalInt(oPC, SUBRACE_TAG + "SB_NITE_OCE", TRUE);
           DeleteLocalInt(oPC, SUBRACE_TAG + "SB_DAY_OCE");
       }
    }
}







//void main() { }
