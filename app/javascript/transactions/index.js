import {Chart, registerables} from 'chart.js'

Chart.register(...registerables);

function months_between_dates(end_date, start_date) {
    let months = end_date.getMonth() - start_date.getMonth() + 12 * (end_date.getFullYear() - start_date.getFullYear())
    if (end_date.getUTCDate() > start_date.getUTCDate()) {
        months += 1
    }
    return months
}

function get_filtered_dates(transactions) {
    let filtered_dates = {
        mo_1: [],
        mo_3: [],
        mo_6: [],
        ytd: [],
        yr_1: [],
        yr_2: []
    };
    transactions.forEach(function (t) {
        const months = months_between_dates(new Date(), new Date(t.date));
        if (months <= 1) {
            filtered_dates.mo_1.push(t)
        }
        if (months <= 3) {
            filtered_dates.mo_3.push(t)
        }
        if (months <= 6) {
            filtered_dates.mo_6.push(t)
        }
        const first_date_of_year = new Date(new Date().getFullYear(), 0, 2)
        if (months <= months_between_dates(new Date, first_date_of_year)) {
            filtered_dates.ytd.push(t)
        }
        if (months <= 12) {
            filtered_dates.yr_1.push(t)
        }
        if (months <= 24) {
            filtered_dates.yr_2.push(t)
        }
    })
    return filtered_dates;
}

function updateChartRange(range) {
    console.log('Hola k ase')
}

const transactions = chart_data;
const filtered_dates = get_filtered_dates(transactions);

let chart = new Chart(
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
            labels: transactions.map(row => row.date),
            datasets: [
                {
                    label: 'Running Balance',
                    data: transactions.map(row => row.running_balance)
                },
                {
                    label: 'Tendency',
                    fill: false,
                    borderDash: [10, 5]
                }
            ]
        }
    }
);

drawTendencyLine(chart, transactions);

function updateTransactionChart(chart, transactions, newData) {
    chart.data.labels = [];
    chart.data.datasets.forEach((dataset) => {
        dataset.data = [];
    });

    chart.data.labels = newData.map(t => t.date);
    chart.data.datasets[0].data = newData.map(t => t.running_balance);
    drawTendencyLine(chart, newData);
}

function drawTendencyLine(chart, data) {
    const tendency_start = data.at(0).running_balance;
    const tendency_end = data.at(-1).running_balance;
    const steps = (tendency_end - tendency_start) / (data.length - 1);
    let tendency_line = []

    for (let i = 0; i <= transactions.length; i++) {
        tendency_line.push(tendency_start + (steps * i))
    }

    chart.data.datasets[1].data = tendency_line
    chart.update();
}

window.updateChartRange = function updateChartRange(range) {
    updateTransactionChart(chart, transactions, filtered_dates[range])
}
