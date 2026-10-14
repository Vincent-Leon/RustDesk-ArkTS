export enum RemoteSessionOrientationMode {
  FOLLOW_DESKTOP = 'follow_desktop',
  /** 跟随重力感应旋转，同时遵守系统的旋转锁定开关 */
  AUTO_ROTATION = 'auto_rotation',
  PORTRAIT = 'portrait',
  LANDSCAPE = 'landscape',
}

export class RemoteSessionOrientationPolicy {
  static resolve(deviceType: string, remoteWidth: number, remoteHeight: number): RemoteSessionOrientationMode {
    if (!Number.isFinite(remoteWidth) || !Number.isFinite(remoteHeight)
      || remoteWidth <= 0 || remoteHeight <= 0) {
      return RemoteSessionOrientationMode.FOLLOW_DESKTOP;
    }
    const normalizedDeviceType = deviceType.trim().toLowerCase();
    if (normalizedDeviceType === 'tablet') {
      return RemoteSessionOrientationMode.FOLLOW_DESKTOP;
    }
    if (normalizedDeviceType === '2in1') {
      return RemoteSessionOrientationMode.LANDSCAPE;
    }
    if (normalizedDeviceType === 'phone') {
      // 不按远端屏幕比例锁死方向：用户转动手机时画面应当跟着转
      return RemoteSessionOrientationMode.AUTO_ROTATION;
    }
    return RemoteSessionOrientationMode.FOLLOW_DESKTOP;
  }
}
