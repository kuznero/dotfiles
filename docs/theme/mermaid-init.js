// ref: https://mermaid.js.org/config/theming.html
var config = {
  theme: 'neutral', // 'default', 'forest', 'dark', 'neutral', 'null'
  look: 'handDrawn',
  logLevel: 'fatal',
  securityLevel: 'strict',
  startOnLoad: true,
  arrowMarkerAbsolute: false,
  themeVariables: {
    fontFamily: 'Montserrat',
  },
  er: {
    diagramPadding: 20,
    layoutDirection: 'TB',
    minEntityWidth: 100,
    minEntityHeight: 75,
    entityPadding: 15,
    stroke: 'gray',
    fill: 'honeydew',
    fontSize: 12,
    useMaxWidth: true,
  },
  flowchart: {
    diagramPadding: 8,
    htmlLabels: true,
    curve: 'basis',
  },
  sequence: {
    diagramMarginX: 50,
    diagramMarginY: 10,
    actorMargin: 50,
    width: 150,
    height: 65,
    boxMargin: 10,
    boxTextMargin: 5,
    noteMargin: 10,
    messageMargin: 35,
    messageAlign: 'center',
    mirrorActors: true,
    bottomMarginAdj: 1,
    useMaxWidth: true,
    rightAngles: false,
    showSequenceNumbers: false,
  },
  gantt: {
    titleTopMargin: 25,
    barHeight: 20,
    barGap: 4,
    topPadding: 50,
    leftPadding: 75,
    gridLineStartPadding: 35,
    fontSize: 11,
    fontFamily: '"Open-Sans", "sans-serif"',
    numberSectionStyles: 4,
    axisFormat: '%Y-%m-%d',
    topAxis: false,
  }
};

mermaid.initialize(config);

document.addEventListener("DOMContentLoaded", () => {
  const updateMermaidTheme = () => {
    const htmlElement = document.documentElement;
    var theme = localStorage.getItem('mdbook-theme');
    config.theme = theme === "latte" ? "neutral" : "dark";
    mermaid.initialize(config);
    document.querySelectorAll('.mermaid').forEach((el) => {
      const graphDefinition = el.getAttribute('data-graph-definition') || el.innerText.trim(); // Retrieve stored definition or original text
      el.setAttribute('data-graph-definition', graphDefinition); // Store definition for future use
      el.innerHTML = graphDefinition; // Reset content to raw Mermaid definition
      el.removeAttribute('data-processed'); // Mark the diagram for re-rendering
    });
    mermaid.init(undefined, document.querySelectorAll('.mermaid'));
  };

  updateMermaidTheme();

  // Observe changes to the `class` attribute on the <html> element
  const observer = new MutationObserver(updateMermaidTheme);
  observer.observe(document.documentElement, {
    attributes: true,
    attributeFilter: ["class"],
  });
});
