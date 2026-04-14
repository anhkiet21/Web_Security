function escapeHtml(text) {
  if (text == null) return "";
  var div = document.createElement("div");
  div.appendChild(document.createTextNode(text));
  return div.innerHTML;
}
