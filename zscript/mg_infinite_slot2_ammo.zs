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

class mg_InfiniteSlot2AmmoEventHandler : EventHandler
{

// public: // EventHandler /////////////////////////////////////////////////////

  override
  void WorldTick()
  {
    giveMinSlot2Ammo();
  }

// private: ////////////////////////////////////////////////////////////////////

  private
  void giveMinSlot2Ammo()
  {
    PlayerInfo player = players[consolePlayer];
    if (player == null) { return; }

    if (enabledCvar == NULL)
    {
      enabledCvar = CVar.GetCVar("m8f_wm_InfiniteSlot2Ammo", player);
    }

    if (!enabledCvar.GetBool()) { return; }

    Actor actor = player.mo;
    if (actor == null) { return; }

    int nWeaponsInSlot2 = player.weapons.SlotSize(2);
    for (int i = 0; i < nWeaponsInSlot2; ++i)
    {
      let weaponType = player.weapons.GetWeapon(2, i);
      let weap       = GetDefaultByType(weaponType);

      {
        let amm1 = weap.AmmoType1;
        int use1 = weap.AmmoUse1;
        if (amm1 && actor.CountInv(amm1) < use1)
        {
          actor.GiveInventory(amm1, use1);
        }
      }
      {
        let amm2 = weap.AmmoType2;
        int use2 = weap.AmmoUse2;
        if (amm2 && actor.CountInv(amm2) < use2)
        {
          actor.GiveInventory(amm2, use2);
        }
      }
    }
  }

// private: ////////////////////////////////////////////////////////////////////

  private transient CVar enabledCvar;

} // class mg_InfiniteSlot2AmmoEventHandler
