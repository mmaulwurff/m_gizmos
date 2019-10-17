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

class mg_JunkEventHandler : EventHandler
{

  // public: // EventHandler ///////////////////////////////////////////////////

  override
  void NetworkProcess(ConsoleEvent event)
  {
    PlayerInfo player = players[event.player];
    if (event.name == "mg_throw_junk") { planThrowJunk(player); }
  }

  override
  void WorldTick()
  {
    if (_plannedTime != level.time) { return; }

    switch (_plannedAction)
    {
      case NOTHING: break;

      case THROW_JUNK: throwJunk(); break;

      default: console.printf("gm Warning: Unknown planned action.");
    }
  }

  // private: //////////////////////////////////////////////////////////////////

  private
  void planThrowJunk(PlayerInfo player)
  {
    if (_plannedAction != NOTHING) { return; }

    _player        = player;
    _plannedAction = THROW_JUNK;
    _plannedTime   = level.time + _planDelay;
  }

  private
  void throwJunk()
  {
    _plannedAction = NOTHING;

    if (!_player) { return; }

    Actor playerPawn = _player.mo;
    if (!playerPawn) { return; }

    playerPawn.A_PlaySound("wmenu/throw", CHAN_BODY);
    playerPawn.SoundAlert(playerPawn, false);

    double angle      = playerPawn.angle;
    double pitch      = playerPawn.pitch;
    double distance   = 2048.0;
    int    damage     = 0;
    string damageType = "None";
    string puffType   = "gm_JunkPuff";
    int    flags      = LAF_NOIMPACTDECAL;
    playerPawn.LineAttack(angle, distance, pitch, damage, damageType, puffType, flags);
  }

  // private: ///////////////////////////////////////////////////////lllllllllll

  enum PlannedActions
  {
    NOTHING,
    THROW_JUNK,
  }

  private int        _plannedAction;
  private PlayerInfo _player;
  private int        _plannedTime;

  const _planDelay = 5;

} // class mg_JunkEventHandler

class gm_JunkPuff : BulletPuff
{

// public: /////////////////////////////////////////////////////////////////////

  Default
  {
    +BLOODLESSIMPACT;
    +PUFFONACTORS;
    +NOBLOCKMAP;
    +NOGRAVITY;
    -ALLOWPARTICLES;
    +RANDOMIZE;
    RenderStyle "Translucent";
    Alpha 0.5;
    VSpeed 0.2;
    Mass 5;
    XScale 0.25;
    YScale 0.25;
  }

   States
   {
   Spawn:
     TNT1 A 0;
    // Intentional fall-through
   Melee:
     TNT1 A 0 A_SpawnItemEx("gm_Junk");
     WMPF CD 4;
     Stop;
  }

} // class gm_JunkPuff

class gm_Junk : IceChunk
{

// public: /////////////////////////////////////////////////////////////////////

  Default
  {
    Gravity 0.5;
    XScale 0.25;
    YScale 0.25;
  }

  States
  {
  Spawn:
    TNT1 A 0;
    ICEC A 99;
    Stop;
  }

} // class gm_Junk
