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

class mg_WeaponChangeSoundEventHandler : EventHandler
{

// public: // EventHandler /////////////////////////////////////////////////////

  override
  void WorldTick()
  {
    PlayerInfo player = players[consolePlayer];

    if (isPlayingSoundOnWeaponChangeCvar == NULL)
    {
      isPlayingSoundOnWeaponChangeCvar = Cvar.GetCvar("m8f_wm_PlaySoundOnWeaponChange", player);
    }
    if (soundOnWeaponChangeCvar == NULL)
    {
      soundOnWeaponChangeCvar = Cvar.GetCvar("mg_weapon_change_sound", player);
    }

    if (!isPlayingSoundOnWeaponChangeCvar.GetBool()) return;

    let pawn = player.mo;
    if (pawn == NULL) return;

    if (player.ReadyWeapon != weaponBefore)
    {
      pawn.A_PlaySound(soundOnWeaponChangeCvar.GetString(), CHAN_AUTO);
    }

    weaponBefore = player.ReadyWeapon;
  }

// private: ////////////////////////////////////////////////////////////////////

  private transient Cvar isPlayingSoundOnWeaponChangeCvar;
  private transient Cvar soundOnWeaponChangeCvar;

  private Weapon weaponBefore;

} // class mg_WeaponChangeSoundEventHandler
