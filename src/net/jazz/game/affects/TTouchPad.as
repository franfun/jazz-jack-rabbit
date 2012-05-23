    [Embed(source="../../../../../res/joystick.png")]
    protected static var Joystic:Class;
    [Embed(source="../../../../../res/shoot.png")]
    protected static var Shoot:Class;

    private var mJoystick:Entity;
    private var mShootB:Entity;

    private var mVirtualRight:Rectangle = new Rectangle(50, 0, 30, 60);
    private var mVirtualLeft:Rectangle = new Rectangle(0, 0, 30, 60);
    private var mVirtualUp:Rectangle = new Rectangle(0, 0, 80, 30);
    private var mVirtualShoot:Rectangle = new Rectangle(0, 0, 30, 30);
    private var mVirtualNext:Rectangle = new Rectangle(30, 0, 30, 30);

    private var mLeftDown:Boolean = false;
    private var mRightDown:Boolean = false;
    private var mUpDown:Boolean = false;
    private var mShootDown:Boolean = false;
    private var mNextDown:Boolean = false;

      mJoystick = joystick;
      mVirtualUp.x += mJoystick.x;
      mVirtualUp.y += mJoystick.y;
      mVirtualLeft.x += mJoystick.x;
      mVirtualLeft.y += mJoystick.y;
      mVirtualRight.x += mJoystick.x;
      mVirtualRight.y += mJoystick.y;
      mShootB = shootB;
      mVirtualShoot.x += mShootB.x;
      mVirtualShoot.y += mShootB.y;
      mVirtualNext.x += mShootB.x;
      mVirtualNext.y += mShootB.y;

      var l:Boolean = false;
      var r:Boolean = false;
      var u:Boolean = false;
      var s:Boolean = false;
      var n:Boolean = false;
      var moved:Array;
      if((moved = TouchPad.touchPointsMoved()).length > 0) {
        var res:String = "";
        for each(var id:int in moved) {
            var p:Point = TouchPad.getPoint(id);
            res += id + ":" + p.x + "x" + p.y + "  ";
            if(mVirtualUp.containsPoint(p)) u = true;
            if(mVirtualLeft.containsPoint(p)) l = true;
            if(mVirtualRight.containsPoint(p)) r = true;
            if(mVirtualShoot.containsPoint(p)) s = true;
            if(mVirtualNext.containsPoint(p)) n = true;
          }
        FP.console.log(res);
      }
      if(l != mLeftDown) {
        if(l) mControl.StartLeft();
        else mControl.StopLeft();
        mLeftDown = l;
      }
      if(r != mRightDown) {
        if(r) mControl.StartRight();
        else mControl.StopRight();
        mRightDown = r;
      }
      if(u != mUpDown) {
        if(u) mJump.StartJump();
        else mJump.StopJump();
        mUpDown = u;
      }
      if(s != mShootDown) {
        if(s) mShoot.StartShoot();
        else mShoot.StopShoot();
        mShootDown = s;
      }
      if(n != mUpDown) {
        if(n) mShoot.nextWeapon();
        mNextDown = n;
      }

    public override function init():void {
      if(TouchPad.available) {
        FP.console.log("Touchpad available!");
        TouchPad.enable();
      } else {
        FP.console.log("Touchpad not available... :(");
      }
    }

      mJoystick.graphic = new Image(Joystic);
      mJoystick.layer = 0;
      mJoystick.x = 220;
      mJoystick.y = 150;
      mJoystick.graphic.scrollX = mJoystick.graphic.scrollY = 0;

      mShoot.graphic = new Image(Shoot);
      mShoot.layer = 0;
      mShoot.x = 20;
      mShoot.y = 180;
      mShoot.graphic.scrollX = mShoot.graphic.scrollY = 0;

      mLevel.add(mJoystick);
      mLevel.add(mShoot);
