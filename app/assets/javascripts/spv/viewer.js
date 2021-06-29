function initGraph(externalinks, div, x, y) {
  d3.select(div).attr("style", "width:" + x + "px;height:" + y + "px;display:block;overflow:hidden;padding:2px;border:1px solid black");
  const links = JSON.parse(JSON.stringify(externalinks));
  console.log(links);
  let nodes = {};
  links.forEach(function (link) {
    if ("" + link.idA == "undefined")
      link.source = nodes[link.source] || (nodes[link.source] = {name: link.source, category: link.typeA, id: link.idA});
    else 
      link.source = nodes[link.idA] || (nodes[link.idA] = {name: link.source, category: link.typeA, id: link.idA});
    if ("" + link.idB == "undefined")
      link.target = nodes[link.target] || (nodes[link.target] = {name: link.target, category: link.typeB, id: link.idB});
    else 
      link.target = nodes[link.idB] || (nodes[link.idB] = {name: link.target, category: link.typeB, id: link.idB});
  });
  console.log(nodes);
  console.log(mitochondria);
}
