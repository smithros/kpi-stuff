using System;
using System.Windows.Forms;

namespace oop_lab3_forms
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            chart1.ChartAreas[0].AxisX.Title = "Середній Час";
            chart1.ChartAreas[0].AxisY.Title = "Інтенсивність";
            chart1.Series.Add("");
     
            for (int intensity = 30; intensity > 0; intensity--)
            {
                int delay = intensity;
                var gen = GenFactory.getGenerator(3, 10, 0, 10);
                var rnd = new Random();

                var pq = new PriorityQueue(30);
                for (int i = 0; i < 10000; ++i)
                {
                    if (--delay == 0)
                    {
                        gen.MoveNext();
                        pq.add(gen.Current);
                        delay = intensity;
                    }
                    pq.tick();
                }
                int tavrg = pq.avt / pq.number;
                chart1.Series[0].Name = "Середній час від інтенсивності";
                chart1.Series[0].ChartType = System.Windows.Forms.DataVisualization.Charting.SeriesChartType.Line;
                chart1.Series[0].Points.AddXY((intensity), tavrg);

                //chart1.Series[1].Name = "Середій час простою від інтенсивності";
                //chart1.Series[1].ChartType = System.Windows.Forms.DataVisualization.Charting.SeriesChartType.Line;
                //chart1.Series[1].Points.AddXY((intensity), pq.dt / 100.0);

            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            chart2.ChartAreas[0].AxisY.Title = "Середній Час";
            chart2.ChartAreas[0].AxisX.Title = "Пріоритет";
            chart2.Series.Add("");

            for (int intensity = 30; intensity > 0; intensity--)
            {
                int delay = intensity;
                var gen = GenFactory.getGenerator(3, 10, 0, 10);
                var rnd = new Random();

                var pq = new PriorityQueue(30);
                for (int i = 0; i < 10000; ++i)
                {
                    if (--delay == 0)
                    {
                        gen.MoveNext();
                        pq.add(gen.Current);
                        delay = 30;
                    }
                    pq.tick();
                }
                int tavrg = pq.avt / pq.number;
                chart2.Series[0].Name = "Середній час від пріоритету";
                chart2.Series[0].ChartType = System.Windows.Forms.DataVisualization.Charting.SeriesChartType.Line;
                //chart2.Series[0].Points.AddXY(tavrg / 10, pq.number / 10);
                chart2.Series[0].Points.AddXY(200, 20);
            }
        }


        private void button3_Click(object sender, EventArgs e)
        {
            chart3.ChartAreas[0].AxisY.Title = "% простою";
            chart3.ChartAreas[0].AxisX.Title = "Інтенсивність";
            chart3.Series.Add("");

            for (int intensity = 30; intensity > 0; intensity--)
            {
                int delay = intensity;
                var gen = GenFactory.getGenerator(3, 10, 0, 10);
                var rnd = new Random();

                var pq = new PriorityQueue(30);
                for (int i = 0; i < 10000; ++i)
                {
                    if (--delay == 0)
                    {
                        gen.MoveNext();
                        pq.add(gen.Current);
                        delay = intensity;
                    }
                    pq.tick();
                }
                int tavrg = pq.avt / pq.number;
                chart3.Series[0].Name = "% простою від інтенсивності";
                chart3.Series[0].ChartType = System.Windows.Forms.DataVisualization.Charting.SeriesChartType.Line;
                chart3.Series[0].Points.AddXY((intensity), pq.dt / 100);
            }
        }
    }
}
