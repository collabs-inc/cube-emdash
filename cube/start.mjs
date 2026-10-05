import os from 'node:os';
import path from 'node:path';
import { runDesktop } from './desktop/start.mjs';

const dataDir = path.resolve(process.env.CUBE_EMDASH_DATA_DIR || path.join(process.env.XDG_DATA_HOME || path.join(os.homedir(), '.local/share'), 'cube-emdash'));
const executable = path.join(process.env.XDG_CACHE_HOME || path.join(os.homedir(), '.cache'), 'cube-emdash', `1.2.7-linux-${process.arch}`, 'opt/Emdash/Emdash');
const profile = path.join(dataDir, 'profile');
await runDesktop({name:'Emdash',executable,args:[`--user-data-dir=${profile}`,'--ozone-platform=x11'],dataDir,env:{
  EMDASH_USER_DATA_DIR:profile, TELEMETRY_ENABLED:'false', APPIMAGE:undefined, APPDIR:undefined,
}});
