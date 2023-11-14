import {Chart, registerables} from 'chart.js'

Chart.register(...registerables);

(async function () {
    const data = transactions;

    new Chart(
        document.getElementById('acquisitions'),
        {
            type: 'line',
            data: {
                labels: data.map(row => row.date),
                datasets: [
                    {
                        label: 'Running Balance',
                        data: data.map(row => row.running_balance)
                    }
                ]
            }
        }
    );
})();