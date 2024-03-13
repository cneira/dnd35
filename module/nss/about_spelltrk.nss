// 5.3
/*
Archaegeo's Spell Tracking System
December 2002

There is a well known and well used cheat where a PC can quit and return to get
all of their spells and feats back to get around resting restrictions.

The only solution before this was to strip all spells and feats from someone on
login, so that they must rest to get them back.

The Spell Tracking system tracks the use of each individual spell.  Then when
the player quits and returns, their spells and selected feats are reset to what
they were when they logged out.

If you are using HCR with the HCR Spell System add-on, then set up will be
easier.  If you are not, it will take you a little longer, and your module size
will grow, but your players will love you for it if you have been stripping all
spells and feats before now.

For those already using the HCR Spell System add-on, this will take you about
5-10 minutes to implement.  For others, probably 1-2 hours of some tedium.

NOTE: If you are already using some sort of stripping system, you should turn
it off if you use this one.

This system only tracks the following feats currently.  Instructions for adding
additional feats are listed below.  ALL SPELLS are tracked.

FEATS SUPPORTED (you must still edit the nw_s2_ script as show below)
Lay On Hands
Summon Animal Companion
Summon Familiar
Death Domain Power (summon shadow)
Turn Undead

***************************************************
SETUP - ON A NON HCR SYSTEM (or any system that doesnt have an include file in
all nw_s0 and nw_s2 scripts.  HCR with HCR Spell System add-on are covered
below)

1) Import the ERF into your module.  You will need to overwrite nothing.
2) Place st_on_enter in the OnClientEnter Event of your module.  If you have
something there already, just place the following line somewhere that it will
be executed by an entering player.

    ExecuteScript( "st_strip_talents", GetEnteringObject());

3) Place the st_on_rest in the OnPlayerRest Event of your module.  If you have
something there already, just place the following line somewhere that it will
be executed by a player who finishes resting successfully.

    if(GetLastRestEventType()==REST_EVENTTYPE_REST_FINISHED)
        ExecuteScript("st_resetspells", GetLastPCRested());

4) For each spell you wish to track, you must open its script by going to the
script editor and changing it so that the start of it looks like:

#include "inc_spell_track"
void main()
{
    spell_track();

this will set up the tracking.  Click compile and you are done with that spell,
procede to the next one.

NOTE:  This will make your module MUCH larger if you do this for all nw_s0_ and
nw_s2_ series scripts.

***************************************************
Setup on an HCR system or any module with an include file already in each spell
(nw_s0_*) and feat spell (nw_s2_*) script.

Follow steps 1 through 3 above.

4) Open wm_include (or whatever your include file is that has a call that is
made by all spells).  In wm_include, at the start of the WildMagicOverride()
function call, insert:

// SPELL TRACKING BEGIN
    if(GetSpellCastItem()==OBJECT_INVALID)
    {
        object oW=GetLastSpellCaster();
        if(oW==OBJECT_INVALID) oW=OBJECT_SELF;
        string sNm=GetName(oW);
        string sPC=GetPCPlayerName(oW);
        int nSp=GetSpellId();
        object oMd=GetModule();
        int nTm=GetLocalInt(oMd, "SPTRK"+sNm+sPC+IntToString(nSp));
        SetLocalInt(oMd,"SPTRK"+sNm+sPC+IntToString(nSp), (nTm+1));
    }
// END SPELL TRACKING

Then save wm_include and do a full script build.

***************************************************

FOR ADVANCED USERS.
To add additional feats to track, use the process below.  Feats do not have a
script directly associated with them, so you must convert the spell effect to
the feat number to be decremented.

1) Open the associated nw_s2_ script for the feat of concern.
2) In it, place the following line:

SendMessageToPC(GetFirstPC(),"SPELLID "+IntToString(GetSpellID()));

3) Go in your module and use the feat.  You should get a SPELLID report.
4) Open inc_spell_track
5) At line 60, in the switch statement, add a line that looks like the
following:

        case 318 : nSpellToFeat=FEAT_SUMMON_FAMILIAR; break;

where 318 is the SPELLID number you received, and where FEAT_SUMMON_FAMILIAR is
the constant of the feat you wish to track.  (These are in the script editor
under the "Constants" button.

6) Delete the line added in step 2 above, and in the nw_s2_ of concern, add:

#include "inc_spell_track"
void main()
{
    spell_track();

Thats it, your now tracking a new feat.
*/
void main()
{

}
