var LINK_STRENGTH = 10;
var MIN_SIZE = 40;
var Link = function (node1, node2, length) {
    //private
    var _length, _nodes;
    //privileged
    this.getNodes = function () {
        return _nodes;
    };
    this.getLength = function () {
        return _length;
    };
    this.setLength = function (length) {
        if (length < MIN_SIZE) {
            _length = MIN_SIZE;
        }
        else {
            _length = length;
        }
        return this;
    };
    //constructor
    if (node1 === node2) {
        throw new Error("You cannot link a node to its self!");
    }
    _nodes = [node1, node2];
    node1.attachNode(this);
    node2.attachNode(this);
    this.setLength(length || getRandomInt(40, 80));
    Link.allLinks.push(this);
}
//public methods
Link.prototype.getOppNode = function(node){
        var nodes = this.getNodes();
        return nodes[(nodes[0] === node) ? 1 : 0]
}
Link.prototype.display = function(context) {
    var nodes = this.getNodes();
    context.beginPath();
    context.strokeStyle = '#000000';
    context.lineWidth = 3;
    context.moveTo(nodes[0].getPos().x, nodes[0].getPos().y);
    context.lineTo(nodes[1].getPos().x, nodes[1].getPos().y);
    context.stroke();
};
Link.prototype.getForce = function(){
    var nodes = this.getNodes();
    var nodeDistance = new Vector2(nodes[0].getPos().x - nodes[1].getPos().x, nodes[0].getPos().y - nodes[1].getPos().y).length();
    var diff = (this.getLength() - nodeDistance)/this.getLength()*LINK_STRENGTH;
    return -diff;
}
//static
Link.allLinks = [];
Link.getAll = function(){
    return Link.allLinks;
}
