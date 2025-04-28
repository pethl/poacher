import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"
import "chartjs-adapter-dayjs"

export default class extends Controller {
  connect() {
    console.log("Yieldchart controller connected!")

    const makeType = this.element.dataset.makeType
    const chartData = window.YIELD_DATA[makeType] || []

    console.log("Make type:", makeType)
    console.log("Chart data:", chartData)

    if (!chartData.length) {
      console.warn("No chart data for make type:", makeType)
      return
    }

    const ctx = this.element.getContext("2d")

    new Chart(ctx, {
      type: "line",
      data: {
        datasets: [
          {
            label: "Yield (%)",
            data: chartData,
            borderColor: "rgb(75, 192, 192)",
            tension: 0.1
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          x: {
            type: "time",
            time: { unit: "day" }
          },
          y: {
            beginAtZero: true
          }
        },
        plugins: {
          legend: { display: false }
        }
      }
    })
  }
}
