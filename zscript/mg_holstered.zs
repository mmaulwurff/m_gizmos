/* Copyright Alexander 'm8f' Kromm (mmaulwurff@gmail.com) 2019
 *
 * This file is a part of m_gizmos.
 *
 * m_gizmos is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * m_gizmos is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * m_gizmos.  If not, see <https://www.gnu.org/licenses/>.
 */

// initially, weapon holstering was implemented by setting player.PendingWeapon
// to null.
// Some mods (namely, Weapons of Saturn and Accessories to Murder) freeze
// when player's pending weapon is set to null.
// So, now the PendingWeapon is set to a dummy.

class mg_HolsterEventHandler : EventHandler
{

// public: // EventHandler /////////////////////////////////////////////////////

  override
  void NetworkProcess(ConsoleEvent event)
  {
    PlayerInfo player = players[event.player];
    if (event.name == "mg_holster") { toggleHolster(player); }
  }

// private: ////////////////////////////////////////////////////////////////////

  private static
  void toggleHolster(PlayerInfo player)
  {
    let pawn = player.mo;
    if (pawn == NULL) return;

    bool isHolstered = (pawn.CountInv("mg_Holstered") > 0);
    if (isHolstered) unholster(player);
    else             holster(pawn, player);
  }

  private static
  void holster(PlayerPawn pawn, PlayerInfo player)
  {
    pawn.GiveInventory("mg_Holstered", 1);
    player.PendingWeapon = Weapon(pawn.FindInventory("mg_Holstered"));
  }

  private static
  void unholster(PlayerInfo player)
  {
    mg_Holstered.Unholster(player);
  }

} // class mg_HolsterEventHandler

class mg_Holstered : Weapon
{

// public: /////////////////////////////////////////////////////////////////////

  Default
  {
    +Inventory.UNDROPPABLE
    +Weapon.NOALERT
    +Weapon.CHEATNOTWEAPON

    Weapon.SlotNumber 0;
  }

  States
  {
    Ready:
      TNT1 A 1 A_WeaponReady;
      Wait;

    Select:
      TNT1 A 0 Holster(player);
      TNT1 A 1 A_Raise;
      Wait;

    Deselect:
      TNT1 A 0 Unholster(player);
      Stop;

    Fire:
      Goto Ready;
  }

// public: /////////////////////////////////////////////////////////////////////

  static
  void Unholster(PlayerInfo player)
  {
    let holstered = mg_Holstered(player.readyWeapon);
    if (holstered == null) { return; }

    RestoreOriginalProperties(holstered, player);

    player.mo.A_TakeInventory("mg_Holstered");
  }

// private: //////////////////////////////////////////////////////////////////

  private static
  void Holster(PlayerInfo player)
  {
    let holstered = mg_Holstered(player.readyWeapon);
    if (holstered == null) { return; }

    SaveOriginalProperties(holstered, player);

    MaybeSetFov(player);
    MaybeSetSpeed(holstered, player);
  }

  private static
  void MaybeSetFov(PlayerInfo player)
  {
    bool fovChangeEnabled = CVar.GetCvar("m8f_wm_HolsterFovEnabled", player).GetInt();
    if (fovChangeEnabled)
    {
      double fovHolstered = CVar.GetCvar("m8f_wm_HolsterFov", player).GetFloat();
      player.SetFov(fovHolstered);
    }
  }

  private static
  void MaybeSetSpeed(mg_Holstered holstered, PlayerInfo player)
  {
    double holsterSpeedMultiplier = CVar.GetCvar("M8fWeaponMenuHolsterSpeedMultiplier", player).GetFloat();
    if (holsterSpeedMultiplier != 0.0)
    {
      player.mo.A_SetSpeed(holstered.originalSpeed * holsterSpeedMultiplier);
    }
  }

  private static
  void SaveOriginalProperties(mg_Holstered holstered, PlayerInfo player)
  {
    holstered.originalFov   = player.fov;
    holstered.originalSpeed = player.mo.speed;
  }

  private static
  void RestoreOriginalProperties(mg_Holstered holstered, PlayerInfo player)
  {
    player.SetFov(holstered.originalFov);
    player.mo.A_SetSpeed(holstered.originalSpeed);
  }

// private: //////////////////////////////////////////////////////////////////

  private double originalFov;
  private double originalSpeed;

} // class mg_Holstered
