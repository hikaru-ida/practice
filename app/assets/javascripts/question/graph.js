$(function() {
  function createColorArray(length) {
    let colors = ["#54ca76", "#f5c452", "#f2637f", "#9261f3","#31a4e6","55cbcb"]
    if (length <= colors.length) {
      return colors.slice(0, length);
    }
  }

  function createChart(chart_params) {
    ret = new Chart(canvas.getContext("2d"), {
      type: "doughnut",
      data: {
        labels: chart_params["labels"],
        datasets: [{
          data: chart_params["values"],
          backgroundColor: createColorArray(chart_params["labels"].length)
        }]
      },
      options: {
        animation: false
      }
    });
    console.log("hello");
    return ret;
  }
})