
/*
 * @fileOverview
 * next.enchant.js v0.0.1 (2014/01/31)
 * NEXT Engine for enchant.js
 *
 * @author akai_inu
 *
 * @require enchant.js v0.8.0 or later
 *
 * @features
 * - Extended Scene Management
 * - Game Objects
 * - Collisions
 * - Background Layers
 *
 * @usage
 * [Activate]
 *   // Activate with this plugin
 *   enchant('next');
 *
 */
enchant.next = {};

enchant.next.Collider = enchant.Class.create(enchant.Entity, {
  initialize: function(parent, name, collideType, onCollide) {
    var c, radius, surface, x, y;
    this.parent = parent;
    this.name = name;
    this.collideType = collideType != null ? collideType : "arc";
    this.onCollide = onCollide != null ? onCollide : function() {
      return false;
    };
    this.enabled = true;
    this.willDelete = false;
    this.width = this.parent.width;
    this.height = this.parent.height;
    if (DEBUG) {
      switch (this.collideType) {
        case "rect":
          surface = new Surface(this.width, this.height);
          c = surface.context;
          c.beginPath();
          c.rect(0, 0, this.width, this.height);
          break;
        default:
          radius = Math.max(this.width, this.height) / 2;
          surface = new Surface(radius * 2, radius * 2);
          c = surface.context;
          c.beginPath();
          c.arc(radius, radius, radius - 2, 0, Math.PI * 2);
          x = this.width / 2 - radius;
          y = this.height / 2 - radius;
          break;
      }
      c.strokeStyle = "#111";
      c.lineWidth = 1;
      c.stroke();
      this.line = new Sprite(surface.width, surface.height);
      this.line.image = surface;
      this.line.x = x;
      this.line.y = y;
      return this.parent.addChild(this.line);
    }
  }
});

enchant.next.CollisionManager = enchant.Class.create({
  initialize: function() {
    this.colliders = [];
    return this;
  },
  addCollider: function(collider) {
    this.colliders.push(collider);
    return this;
  },
  removeCollider: function(collider) {
    var c, i, _i, _len, _ref;
    i = 0;
    _ref = this.colliders;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      c = _ref[_i];
      if (c === collider) {
        this.colliders.splice(i, 1);
        return true;
      }
      i++;
    }
    return false;
  },
  onenterframe: function() {
    var deleteArray, i, j, obj1, obj2, _i, _j, _len, _len1, _ref;
    deleteArray = [];
    _ref = this.colliders;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      obj1 = _ref[i];
      j = i + 1;
      while (j++ < this.colliders.length) {
        obj2 = this.colliders[j];
        if (obj1.name !== obj2.name && obj1.enabled && obj2.enabled && !obj1.willDelete && !obj2.willDelete && this.hasCollide(obj1, obj2)) {
          if (obj1.onCollide(obj2)) {
            deleteArray.push(obj1);
          }
          if (obj2.onCollide(obj1)) {
            deleteArray.push(obj2);
          }
        }
      }
    }
    for (_j = 0, _len1 = deleteArray.length; _j < _len1; _j++) {
      i = deleteArray[_j];
      this.removeCollider(i);
    }
    return this;
  },
  hasCollide: function(obj1, obj2) {
    var _ref;
    if ((obj1.collideType === (_ref = obj2.collideType) && _ref === "rect")) {
      return obj1.intersect(obj2);
    } else if (obj1.collideType !== obj2.collideType) {
      if (obj1.collideType === "rect") {
        return this.collideRectArc(obj1, obj2);
      } else {
        return this.collideRectArc(obj2, obj1);
      }
    } else {
      return obj1.within(obj2);
    }
  },
  collideRectArc: function(rect, arc) {
    var a, ax, ay, b;
    ax = rect.x + rect._offsetX;
    ay = rect.y + rect._offsetY;
    a = [
      {
        x: ax,
        y: ay
      }, {
        x: ax + rect.width,
        y: ay
      }, {
        x: ax,
        y: ay + rect.height
      }, {
        x: ax + rect.width,
        y: ay + rect.height
      }
    ];
    b = {
      x: arc.x + arc._offsetX,
      y: arc.y + arc._offsetY,
      r: Math.max(arc.width, arc.height) / 2
    };
    return this._collideRectArcFirst(a, b) && this._collideRectArcSecond(a, b) && this._collideRectArcThird(a, b);
  },
  _collideRectArcFirst: function(a, b) {

    /*
    		 * collide with end point and arc
     */
    var i, _i;
    for (i = _i = 0; _i < 4; i = ++_i) {
      if (this.collidePointArc(a[i].x, a[i].y, b.x, b.y, b.r)) {
        return true;
      }
    }
    return false;
  },
  _collideRectArcSecond: function(a, b) {

    /*
    		 * collide with line and arc
     */
    var d2, i, k, n, phd2, pm, pmd2, pq, pqd2, _i;
    n = [[0, 1, 3, 2], [1, 3, 2, 0]];
    for (i = _i = 0; _i < 4; i = ++_i) {
      pq = this.getVector(a[n[0][i]], a[n[1][i]]);
      pm = this.getVector(a[n[0][i]], b);
      dot(this.getDot(pq, pm));
      pqd2 = this.getLength2(pq);
      pmd2 = this.getLength2(pm);
      k = dot / pqd2;
      if (k < 0 || 1 < k) {
        continue;
      }
      phd2 = (dot * dot) / pqd2;
      d2 = pmd2 - phd2;
      if (d2 < b.r * b.r) {
        return true;
      }
    }
    return false;
  },
  _collideRectArcThird: function(a, b) {

    /*
    		 * intersect arc
     */
    var cross, dot, i, pm, pp, _i;
    for (i = _i = 0; _i < 2; i = ++_i) {
      pp = this.getVector(a[i * 3], a[1 + i]);
      pm = this.getVector(a[i * 3], b);
      dot = this.getDot(pp, pm);
      cross = this.getCross(pp, pm);
      theta[i] = Math.atan2(cross, dot);
    }
    return 0 <= theta[0] && theta[0] <= Math.PI / 2 && 0 <= theta[1] && theta[1] <= Math.PI / 2;
  },
  collidePointArc: function(ax, ay, _bx, _by, r) {
    var dx, dy;
    dx = _bx - ax;
    dy = _by - ay;
    return ((dx * dx) + (dy * dy)) < (r * r);
  },
  getVector: function(ax, ay, _bx, _by) {
    return {
      x: _bx - ax,
      y: _by - ay
    };
  },
  getDot: function(a, b) {
    return a.x * b.x + a.y * b.y;
  },
  getCross: function(a, b) {
    return a.x * b.y - a.y * b.x;
  },
  getLength2: function(a) {
    return this.getDot(a, a);
  }
});

enchant.next.CollisionManager.singleton = function() {
  if (enchant.next.CollisionManager._instance == null) {
    enchant.next.CollisionManager._instance = new enchant.next.CollisionManager();
  }
  return enchant.next.CollisionManager._instance;
};


/*
 * DebugBox class
 *
 * @features
 * - show Average FPS
 * - output debug log
 */
enchant.next.DebugBox = enchant.Class.create(enchant.Group, {
  initialize: function(scene) {
    enchant.Group.call(this);
    this.padding = 10;
    this.font = "13px Consolas, 'Courier New', monospace";
    this.permanentText = [];
    this.text = new enchant.Label();
    this.width = scene.width;
    this.text.width = this.width - this.padding;
    this.text.y = this.padding;
    this.text.textAlign = "right";
    this.text.color = "#eee";
    this.text.font = this.font;
    this.bg = new enchant.Entity();
    this.bg.backgroundColor = "rgba(0,0,0,.5)";
    this.bg.width = 0;
    this.bg.height = 0;
    this.bgw = new enchant.Entity();
    this.bgw.backgroundColor = "rgba(255,255,255,.3)";
    this.bgw.width = 0;
    this.bgw.height = 0;
    this.addChild(this.bgw);
    this.addChild(this.bg);
    this.addChild(this.text);
    scene.addChild(this);
    this.time = enchant.next.Time.singleton();
  },
  addPermanentText: function(text) {
    this.permanentText.push(text);
  },
  onenterframe: function() {
    var perm, t, w, _i, _len, _ref;
    t = "FPS : " + this.time.averageFps;
    if (this.permanentText.length > 0) {
      _ref = this.permanentText;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        perm = _ref[_i];
        t += "<br>" + perm;
      }
    }
    this.text.text = t;
    this.permanentText = [];
    w = this.text._boundWidth + (this.padding * 2);
    this.bg.x = this.width - w;
    this.bg.width = w;
    this.bg.height = this.text._boundHeight + (this.padding * 2);
    this.bgw.x = this.width - w;
    this.bgw.width = w;
    this.bgw.height = this.text._boundHeight + (this.padding * 2);
  }
});

enchant.next.DebugBox.singleton = function(scene) {
  if (scene == null) {
    scene = null;
  }
  if (scene) {
    enchant.next.DebugBox._instance = new enchant.next.DebugBox(scene);
  }
  if (enchant.next.DebugBox._instance == null) {
    throw 'You need to singleton with scene first.';
  }
  return enchant.next.DebugBox._instance;
};

Math.clamp = function(val, min, max) {
  if (val > max) {
    return max;
  } else if (val < min) {
    return min;
  } else {
    return val;
  }
};


/*
 * Layer class
 *
 * @features
 * - represents 1 layer in world
 *
 * @usage
 *
 */
enchant.next.Layer = enchant.Class.create(enchant.Group, function() {
  return {
    initialize: function(distance) {
      this.distance = distance;
      enchant.Group.call(this);
    }
  };
});


/*
 * Layer Manager class
 *
 * @features
 * - manages 2D scrollable layers
 *
 */
enchant.next.LayerManager = enchant.Class.create(function() {
  return {
    initialize: function(scene) {
      this.parentScene = scene;
      scene.addChild(this);
      this.layers = [];
    },
    addLayer: function(layer) {
      return this.layers.push(layer);
    }
  };
});

enchant.next.LayerManager.singleton = function(scene) {
  if (scene == null) {
    scene = null;
  }
  if (scene) {
    enchant.next.LayerManager._instance = new enchant.next.LayerManager(scene);
  }
  if (enchant.next.LayerManager._instance == null) {
    throw "You need to singleton with scene first.";
  }
  return enchant.next.LayerManager._instance;
};


/*
 * Time class
 *
 * @features
 * - keep frame elapsed time
 * - get average fps
 *
 * @constructor
 * fps = set Target FPS
 * updateInterval = Update interval for average FPS
 */
enchant.next.Time = enchant.Class.create(enchant.Node, {
  initialize: function(fps, updateInterval) {
    enchant.Node.call(this);
    this.fps = fps != null ? fps : 30;
    this.updateInterval = updateInterval != null ? updateInterval : 0.5;
    this.startTime = performance.now();
    this.now = 0.0;
    this.prevTime = 0.0;
    this.targetElapsed = Math.floor(1000.0 / fps) + 1;
    this.frame = 0;
    this.elapsedms = 0;
    this.elapsedsec = 0.0;
    this.isSlowly = false;
    this.elapsedArray = [];
    this.averageFps = 0;
    this.totalElapsed = 0;
    this.totalElapsedms = 0;
    this.totalElapsedsec = 0.0;
    this.onenterframe();
  },
  onenterframe: function() {
    var elapsed;
    this.frame++;
    this.now = performance.now() - this.startTime;
    elapsed = this.now - this.prevTime;
    this.prevTime = this.now;
    this.elapsedms = elapsed;
    this.elapsedsec = elapsed * 0.001;
    this.isSlowly = elapsed > this.targetElapsed;
    this.totalElapsedms = Math.floor(this.now);
    this.totalElapsedsec = this.totalElapsedms * 0.001;
    this.elapsedArray.push(Math.round(this.elapsedms));
    this.totalElapsed += Math.round(this.elapsedms);
    if (this.elapsedArray.length > this.fps) {
      this.totalElapsed -= this.elapsedArray.shift();
    }
    if (this.frame % (this.fps * this.updateInterval) === 0 && this.elapsedArray.length > 0) {
      this.averageFps = (1000 / (this.totalElapsed / this.elapsedArray.length)).toFixed(3);
    }
  },
  now: function() {
    return this.now;
  }
});

enchant.next.Time.singleton = function(fps, updateInterval) {
  if (fps == null) {
    fps = -1;
  }
  if (updateInterval == null) {
    updateInterval = -1;
  }
  if (fps > 0) {
    enchant.next.Time._instance = new enchant.next.Time(fps, updateInterval);
  } else if (enchant.next.Time._instance == null) {
    enchant.next.Time._instance = new enchant.next.Time();
  }
  return enchant.next.Time._instance;
};


/*
 * Vector class
 *
 * @features
 * - keeps X and Y coordinate
 * - useful static methods
 * - calculate vector something
 *
 */
enchant.next.Vector = enchant.Class.create({
  initialize: function(x, y) {
    this._x = x;
    this._y = y;
    this._radian = Math.atan2(this._y, this._x);
    this._degree = enchant.next.Vector.getDegree(this._radian);
  },
  x: {
    get: function() {
      return this._x;
    },
    set: function(x) {
      this._x = x;
      this._isDirtyRad = true;
      return this._isDirtyDeg = true;
    }
  },
  y: {
    get: function() {
      return this._y;
    },
    set: function(y) {
      this._y = y;
      this._isDirtyRad = true;
      return this._isDirtyDeg = true;
    }
  },
  radian: function() {
    if (this._isDirtyRad) {
      this._radian = Math.atan2(this._x, this._y);
      this._isDirtyRad = false;
    }
    return this._radian;
  },
  degree: function() {
    if (this._isDirtyDeg) {
      this._degree = enchant.next.Vector.getDegree(this.radian);
      this._isDirtyDeg = false;
    }
    return this._degree;
  },
  toString: function() {
    return this.x + ", " + this.y;
  }
});

enchant.next.Vector.toRad = 0.017453292;

enchant.next.Vector.getRadian = function(degree) {
  return degree * 0.017453292;
};

enchant.next.Vector.toDeg = 57.29577951;

enchant.next.Vector.getDegree = function(radian) {
  return radian * 57.29577951;
};

enchant.next.Vector.getForward = function(degree) {
  var radian;
  radian = enchant.next.Vector.getRadian(degree);
  return new Vector(Math.cos(radian), Math.sin(radian));
};

enchant.next.Vector.getLeft = function(degree) {
  var radian;
  radian = enchant.next.Vector.getRadian(degree - 90);
  return new Vector(Math.cos(radian), Math.sin(radian));
};
