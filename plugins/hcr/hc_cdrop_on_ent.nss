// HCR v3.2.0 -
//::////////////////////////////////////////////////////////////////////////////
//:: FileName:  HC_CDrop_On_Ent
//::////////////////////////////////////////////////////////////////////////////
/*

*/
//::////////////////////////////////////////////////////////////////////////////


// * FUNCTION PROTOTYPES


void DropCorpse(object oPC);


// * FUNCTION DEFINITIONS


//::////////////////////////////////////////////////////////////////////////////
void DropCorpse(object oPC)
{
    object oEquip = GetFirstItemInInventory(oPC);
    while (GetIsObjectValid(oEquip))
    {
        if (GetTag(oEquip) == "PlayerCorpse" ||
            GetResRef(oEquip) == "playercorpse")
            DestroyObject(oEquip);
        oEquip = GetNextItemInInventory(oPC);
    }
}
//::////////////////////////////////////////////////////////////////////////////
//void main(){}