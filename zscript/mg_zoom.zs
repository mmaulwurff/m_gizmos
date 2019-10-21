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

class mg_ZoomEventHandler : EventHandler
{

// public: // EventHandler /////////////////////////////////////////////////////

  override
  void NetworkProcess(ConsoleEvent event)
  {
    PlayerInfo player = players[event.player];
    if (event.name == "mg_toggle_zoom")
    {
      if (isWeaponBeingDeselected(player)) return;
      toggleZoom(player);
    }
  }

  override
  void WorldTick()
  {
    PlayerInfo player = players[consolePlayer];
    if (player.PendingWeapon.GetClassName() != "Object" && isZoomed)
    {
      toggleZoom(player);
    }
  }

// private: ////////////////////////////////////////////////////////////////////

  private
  void toggleZoom(PlayerInfo player)
  {
    if (!areCvarsLoaded)
    {
      isNotSlot1MeleeCvar  = Cvar.GetCvar("m8f_wm_IsNotSlot1Melee"     , player);
      zoomedZoomFactorCvar = Cvar.GetCvar("m8f_wm_ZoomFactor"          , player);
      isLaserConnectedCvar = Cvar.GetCvar("m8f_wm_LaserOnZoom"         , player);
      isLowerWeaponCvar    = Cvar.GetCvar("m8f_wm_LowerWeaponOnZoom"   , player);
      zoomSpeedMultCvar    = Cvar.GetCvar("m8f_wm_ZoomSpeedMultiplier" , player);

      isTargetSpyConnectedCvar = Cvar.GetCvar("m8f_wm_TargetSpyOnZoom" , player);
      isTargetSpyEnabledCvar   = Cvar.GetCvar("m8f_ts_enabled"         , player);

      isLaserSightConnectedCvar = Cvar.GetCvar("m8f_wm_LaserOnZoom"    , player);
      isLaserSightEnabledCvar   = Cvar.GetCvar("m8f_wm_ShowLaserSight" , player);

      isSlomoToggledAtZoomIn  = Cvar.GetCvar("m8f_wm_SlomoOnZoomIn"  , player);
      isSlomoToggledAtZoomOut = Cvar.GetCvar("m8f_wm_SlomoOnZoomOut" , player);
      slomoToggleCommandCvar  = Cvar.GetCvar("m8f_sm_externaltoggle");

      areCvarsLoaded = true;
    }

    if (isMelee(player)) return;
    if (isHolstered(player.ReadyWeapon)) return;
    if (player.mo == NULL) return;

    isZoomed = !isZoomed;

    if (isZoomed) zoom(player);
    else        unzoom(player);

    setSlomo(isZoomed);
    setTargetSpy(isZoomed);
    setLaserSight(isZoomed);
  }

  private
  void unzoom(PlayerInfo player)
  {
    Weapon w   = player.ReadyWeapon;
    w.FOVScale = 1;
    player.mo.A_ScaleVelocity(1 / speedMultiplier);

    if (isLowerWeaponCvar.GetBool())
    {
      w.YAdjust -= Y_SHIFT;
    }
  }

  private
  void zoom(PlayerInfo player)
  {
    Weapon w    = player.ReadyWeapon;
    double zoom = 1 / clamp(zoomedZoomFactorCvar.GetFloat(), 0.1, 50.0);
    w.FOVScale  = zoom;

    speedMultiplier = zoomSpeedMultCvar.GetFloat();
    player.mo.A_ScaleVelocity(speedMultiplier);

    if (isLowerWeaponCvar.GetBool())
    {
      w.YAdjust += Y_SHIFT;
    }
  }

// private: ////////////////////////////////////////////////////////////////////

  private static
  bool isHolstered(Weapon w)
  {
    return (w == NULL || w.GetClassName() == "mg_Holstered");
  }

  private
  void setSlomo(bool isZoomed)
  {
    if (slomoToggleCommandCvar == NULL) return;

    Cvar toggleCvar = (isZoomed ? isSlomoToggledAtZoomIn : isSlomoToggledAtZoomOut);
    if (toggleCvar.GetBool())
    {
      slomoToggleCommandCvar.SetBool(true);
    }
  }

  private
  void setTargetSpy(bool isZoomed)
  {
    if (isTargetSpyEnabledCvar == NULL || !isTargetSpyConnectedCvar.GetBool()) return;

    isTargetSpyEnabledCvar.SetBool(isZoomed);
  }

  private
  void setLaserSight(bool isZoomed)
  {
    if (isLaserSightEnabledCvar == NULL || !isLaserSightConnectedCvar.GetBool()) return;

    isLaserSightEnabledCvar.SetBool(isZoomed);
  }

  private static
  bool isWeaponBeingDeselected(PlayerInfo player)
  {
    return player.PendingWeapon.GetClassName() != "Object"; // ?
  }

  private
  bool isMelee(PlayerInfo player)
  {
    let ready = player.ReadyWeapon;
    if (isHolstered(ready)) return true;

    bool located;
    int slot;
    [located, slot] = player.weapons.LocateWeapon(ready.GetClassName());
    if (slot != 1) return false;

    return !isNotSlot1MeleeCvar.GetBool();
  }

// private: ////////////////////////////////////////////////////////////////////

  const Y_SHIFT = 16;

  private bool   isZoomed;
  private double speedMultiplier;

  private transient Cvar isNotSlot1MeleeCvar;
  private transient Cvar zoomedZoomFactorCvar;
  private transient Cvar isLaserConnectedCvar;
  private transient Cvar isLowerWeaponCvar;
  private transient Cvar zoomSpeedMultCvar;
  private transient bool areCvarsLoaded;

  private transient Cvar isTargetSpyConnectedCvar;
  private transient Cvar isTargetSpyEnabledCvar; // external

  private transient Cvar isLaserSightConnectedCvar;
  private transient Cvar isLaserSightEnabledCvar; // external

  private transient Cvar isSlomoToggledAtZoomIn;
  private transient Cvar isSlomoToggledAtZoomOut;
  private transient Cvar slomoToggleCommandCvar; // external

} // class mg_ZoomEventHandler
