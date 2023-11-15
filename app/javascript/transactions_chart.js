import {Chart, registerables} from 'chart.js'

Chart.register(...registerables);

(async function () {
    const data = transactions;
    const avg_start = data.at(0).running_balance;
    const avg_end = data.at(-1).running_balance;
    const steps = (avg_end - avg_start) / data.length;
    let avg_line = []

    for (let i = 0; i <= data.length; i++) {
        avg_line.push(avg_start + (steps * i))
    }

    new Chart(
        document.getElementById('acquisitions'),
        {
            type: 'line',
            options: {
                fill: true,
                elements: {
                    point: {
                        pointStyle: false
                    }
                },
                interaction: {
                    intersect: false,
                    mode: 'index'
                },
                plugins: {
                    tooltip: {
                        // enabled: false
                    }
                }
            },
            data: {
                labels: data.map(row => row.date),
                datasets: [
                    {
                        label: 'Running Balance',
                        data: data.map(row => row.running_balance)
                    },
                    {
                        label: 'Average',
                        data: avg_line,
                        fill: false,
                        borderDash: [10, 5]
                    }
                ]
            }
        }
    );
})();