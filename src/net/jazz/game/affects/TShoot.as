package net.jazz.game.affects {
  import net.flashpunk.FP;
  import net.flashpunk.Sfx;
  import net.flashpunk.graphics.Spritemap;

  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.objects.TBullet;

  public class TShoot extends TAffect {

    [Embed(source="../../../../../res/sounds/shoot.mp3")]
    public static var BlasterSound:Class;
    [Embed(source="../../../../../res/sounds/shoot1.mp3")]
    public static var ToasterSound:Class;
    [Embed(source="../../../../../res/sounds/shoot2.mp3")]
    public static var RFMissileSound:Class;
    [Embed(source="../../../../../res/sounds/shoot3.mp3")]
    public static var LauncherSound:Class;

    private var mShootSounds:Array = [];

    private var mIsShooting:Boolean = false;
    private var mLastShoot:Number = 0;
    private var mMinDelta:Number = 0.5;
    private var mLevel:TLevel;
    private var mType:uint = 0;
    private var mAmmo:Array = [-1, 10, 10, 10];
    private var mWC:TWeaponChanger;

    /**
     * A flag for animation to show shoot
     */
    public var shooted:Boolean = false;

    public function TShoot(wc:TWeaponChanger):void {
      mShootSounds.push(new Sfx(BlasterSound));
      mShootSounds.push(new Sfx(ToasterSound));
      mShootSounds.push(new Sfx(RFMissileSound));
      mShootSounds.push(new Sfx(LauncherSound));
      mWC = wc;
      mWC.updateAmmoCount(mAmmo[mType]);
    }

    public function set level(lvl:TLevel):void { mLevel = lvl; }

    public function StartShoot():void {
      mIsShooting= true;
    }

    public function StopShoot():void {
      mIsShooting = false;
    }

    public function addAmmo(type:uint, count:uint):void {
      var sw:Boolean = mAmmo[1] == 0 && mAmmo[2] == 0 && mAmmo[3] == 0;
      mAmmo[type] += count;
      if(type == mType) mWC.updateAmmoCount(mAmmo[type]);
      if(!sw) return;
      this.type = type;
    }

    public function nextWeapon():void {
      var t:int = mType;
      do {
        t = (t + 1) % 4;
      } while(mAmmo[t] == 0);
      type = t;
    }

    public function set type(t:uint):void {
      mType = t;
      mWC.setWeapon(mType);
      mWC.updateAmmoCount(mAmmo[mType]);
    }

    public function rapid():void {
      mMinDelta *= 0.9;
    }

    //-------------------------------------------------
    //-- TAffect specific implementation
    //-------------------------------------------------
    public override function process():void {
      mLastShoot += FP.elapsed;
      if(mLastShoot < mMinDelta) return;
      if(!mIsShooting) return;
      var bb:TBullet;
      if(mType == 2) {
        bb = buildBullet((target as TObject).x, (target as TObject).y);
        bb.y -= 5;
        bb.subType = 0;
        bb = buildBullet((target as TObject).x, (target as TObject).y);
        bb.y += 5;
        bb.subType = 1;
      } else {
        bb = buildBullet((target as TObject).x, (target as TObject).y);
      }
      mShootSounds[mType].play();
      mLastShoot = 0;
      shooted = true;
      if(mAmmo[mType] < 0) return;
      --mAmmo[mType];
      mWC.updateAmmoCount(mAmmo[mType]);
      if(mAmmo[mType] == 0) nextWeapon();
      // mLevel.AddObject(new TBullet);
    }

    private function buildBullet(x:Number, y:Number):TBullet {
      var bb:TBullet = mLevel.create(TBullet, true) as TBullet;
      bb.init(mType);
      bb.bounds = mLevel;
      bb.layer = 15;
      if(((target as TObject).graphic as Spritemap).flipped) {
        bb.orient = -1;
        bb.x = x;
        bb.y = y + 20;
      } else {
        bb.orient = +1;
        bb.x = x+26;
        bb.y = y + 20;
      }
      return bb;
    }

    public override function Register(target:IAffectable):void {
      super.Register(target);
    }
  }
}
