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
        year_1: [],
        year_2: []
    };
    transactions.forEach(function(t) {
        const months = months_between_dates(new Date(), new Date(t.date));
        if (months <= 1) {
            filtered_dates.mo_1.push(t)
        }
        if(months <= 3) {
            filtered_dates.mo_3.push(t)
        }
        if(months <= 6) {
            filtered_dates.mo_6.push(t)
        }
        const first_date_of_year = new Date(new Date().getFullYear(), 0, 2)
        if(months <= months_between_dates(new Date, first_date_of_year)) {
            filtered_dates.ytd.push(t)
        }
        if(months <= 12) {
            filtered_dates.year_1.push(t)
        }
        if(months <= 24) {
            filtered_dates.year_2.push(t)
        }
    })
    return filtered_dates;
    // return chart.data.filter((t) => months_between_dates(new Date(), new Date(t.date)) <= range)[0]
}

function updateChartRange(range) {
    console.log('Hola k ase')
}

(async function () {
    const transactions = chart;
    const filtered_dates = get_filtered_dates(transactions);
    const avg_start = transactions.at(0).running_balance;
    const avg_end = transactions.at(-1).running_balance;
    const steps = (avg_end - avg_start) / transactions.length;
    let avg_line = []

    for (let i = 0; i <= transactions.length; i++) {
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
                labels: transactions.map(row => row.date),
                datasets: [
                    {
                        label: 'Running Balance',
                        data: transactions.map(row => row.running_balance)
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