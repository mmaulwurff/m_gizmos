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

class mg_BestWeaponEventHandler : EventHandler
{

// public: // EventHandler /////////////////////////////////////////////////////

  override
  void NetworkProcess(ConsoleEvent event)
  {
    PlayerInfo player = players[event.player];
    if (event.name == "mg_best_weapon") { selectBestWeapon(player); }
  }

// private: ////////////////////////////////////////////////////////////////////

  private static
  void selectBestWeapon(PlayerInfo player)
  {
    let pawn = player.mo;
    if (pawn == NULL) return;

    let best = pawn.BestWeapon(NULL);
    if (best != player.ReadyWeapon)
    {
      player.PendingWeapon = best;
    }
  }

} // class mg_BestWeaponEventHandler
