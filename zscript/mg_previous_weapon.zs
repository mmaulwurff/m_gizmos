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

class mg_PreviousWeaponEventHandler : EventHandler
{

// public: // EventHandler /////////////////////////////////////////////////////

  override
  void OnRegister()
  {
    previousWeapon = NULL;
    currentWeapon  = NULL;
    bool isHolstered = false;
  }

  override
  void NetworkProcess(ConsoleEvent event)
  {
    PlayerInfo player = players[event.player];
    if (event.name == "mg_prev_weapon") { selectPreviousWeapon(player); }
  }

  override
  void WorldTick()
  {
    PlayerInfo player = players[consolePlayer];
    updatePreviousWeapon(player);
  }

// private: ////////////////////////////////////////////////////////////////////

  private
  void updatePreviousWeapon(PlayerInfo player)
  {
    let ready = player.ReadyWeapon;

    if (ready == NULL || ready.GetClassName() == "mg_Holstered")
    {
      if (!isHolstered)
      {
        // swap
        let tmp        = currentWeapon;
        currentWeapon  = previousWeapon;
        previousWeapon = tmp;
      }
      isHolstered = true;
      return;
    }

    isHolstered = false;

    if (currentWeapon != ready)
    {
      previousWeapon = currentWeapon;
    }

    currentWeapon = ready;
  }

  private
  void selectPreviousWeapon(PlayerInfo player)
  {
    if (previousWeapon != NULL && player.ReadyWeapon != previousWeapon)
    {
      player.PendingWeapon = previousWeapon;
    }
  }

// private: ////////////////////////////////////////////////////////////////////

  private Weapon currentWeapon;
  private Weapon previousWeapon;
  private bool   isHolstered;

} // class mg_PreivousWeaponEventHandler
