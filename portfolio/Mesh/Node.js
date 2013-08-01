var DAMPING = .7;
var Node = function(pos, radius){
    var _pos, _fixed, _color, _links;
    var _temp_force, _temp_external_force, _velocity;
    var self;

    this.getPos = function (){
        return _pos;
    }
    this.getFixed = function (isFixed) {
        return _fixed;
    }
    this.setFixed = function (isFixed) {
        _fixed = isFixed;
    }
    this.setColor = function (color) {
        _color = color;
    }
    this.getColor = function () {
        return _color;
    }
    this.getAttachedNodes = function () {
        var temp_nodes;
        for(link in _links){
            temp_nodes.push(_links[link].getOppNode(this));
        }
        return temp_nodes;
    }


    function findNetForce(){
        var net = new Vector2(0,0);
        for(link in _links){
            var attached_node = _links[link].getOppNode(self);
            var adjacent_pos = attached_node.getPos();
            var relative_pos = Vector2.sub(adjacent_pos,_pos);
            var force = (relative_pos.length() - _links[link].getLength());
            force = _links[link].getForce();
            var proportion = force/relative_pos.length();
            var directional_force = new Vector2(proportion*relative_pos.x, proportion*relative_pos.y);
            net = Vector2.add(net, directional_force);
            if(_temp_external_force){
                net = Vector2.add(net, _temp_external_force);
                _temp_external_force = new Vector2(0,0);

            }
        }
        return net;
    }

    this.calculateForces = function () {
        _temp_force = findNetForce();
        _velocity = Vector2.add(_velocity, _temp_force);
        _velocity.scale(DAMPING);
    }
    this.move = function () {
        if(_fixed){
            return;
        }
        if(_pos.y >= window.innerHeight-10){
            _pos.y = window.innerHeight-10;
            _pos.x += _velocity.x;
            return;
        }
        _pos = Vector2.add(_pos,_velocity);

    }
    this.attachNode = function (link) {
        _links.push(link);
    }
    this.isAttachedTo = function (node) {
        if(this.getAttachedNodes().indexOf(node) == -1) return false;
        return true;
    }
    this.applyForce= function (vec) {
        _temp_external_force = _temp_external_force || new Vector2(0,0);
        _temp_external_force = Vector2.add(_temp_external_force, vec);
    }
    _links = [];
    _pos = pos
    _velocity = new Vector2(0,0);
    self = this;
}
Node.prototype.display = function (context) {
    context.beginPath();
    context.arc(this.getPos().x, this.getPos().y, 8, 0, 2 * Math.PI, false);
    context.fillStyle = this.getColor();
    context.fill();
    
    if (this.getFixed()){
        context.strokeStyle = '#0000FF';
        context.lineWidth = 5;
    } else {
        context.strokeStyle = '#000000';
        context.lineWidth = 3;
    }
    context.stroke();
};
