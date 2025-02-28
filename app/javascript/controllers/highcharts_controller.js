import { Controller } from "@hotwired/stimulus"
import Highcharts from "highcharts"

export default class extends Controller {
  connect() {
    this.renderChart()
  }

  renderChart() {
    // Get categories and series from the data attributes
    const categories = this.categories
    const seriesData = this.seriesData

    // Render the Highcharts chart
    Highcharts.chart("market-sales-chart", {
      chart: {
        type: "bar" // Horizontal bar chart
      },
      title: {
        text: "Total Market Sales Breakdown"
      },
      xAxis: {
        categories: categories, // Market names (categories)
        title: {
          text: "Markets"
        }
      },
      yAxis: {
        min: 0,
        title: {
          text: "Total Sales (£)"
        }
      },
      series: [
        {
          name: "Total Sales",
          data: seriesData // Total sales per market
        }
      ]
    })
  }

  get categories() {
    return JSON.parse(this.element.getAttribute("data-categories"))
  }

  get seriesData() {
    return JSON.parse(this.element.getAttribute("data-series"))
  }
}
