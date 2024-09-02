#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "mpcache_ui.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    //mpcache_ui::build_mapchce_ui(ui);
    QChart *chart = new QChart();
        //chart->setTitle("饼状图演示图");

        QPieSeries *series = new QPieSeries(chart);
        series->setName("hello");
        series->append("A产品",3143);
        series->append("B产品",2542);
        series->append("C产品",3812);
        series->setLabelsVisible();
        //饼图的大小
        series->setPieSize(1);


        QPieSlice *slice_1 =series->slices().at(0);
        QPieSlice *slice_2 =series->slices().at(1);
        QPieSlice *slice_3 =series->slices().at(2);

        //slice_1->setLabelVisible();// 是否显示指标文字
        slice_1->setExploded();//扇面区分
        slice_1->setExplodeDistanceFactor(0.1);// 扇面分开的距离指数
        //slice_2->setLabelVisible();
        slice_2->setExploded();
        slice_2->setExplodeDistanceFactor(0.1);
        //slice_3->setLabelVisible();
        slice_3->setExploded();
        slice_3->setExplodeDistanceFactor(0.1);

        chart->setAnimationOptions(QChart::AllAnimations);//设置动画效果
        //chart->legend()->setAlignment(Qt::AlignRight);//竖向图例
    chart->legend()->hide();  // 隐藏图例
    chart->setTitle("");

    chart->legend()->hide();        // 隐藏图例

        chart->addSeries(series);
        chart->setTheme(QChart::ChartThemeBlueIcy); //选择主题
        chart->setMargins(QMargins(0, 0, 0, 0));

        QChartView *chartView = new QChartView(chart);
       //chartView->setMinimumSize(ui->verticalLayout_10->size());
        chartView->setContentsMargins(0, 0, 0, 0);

        chartView->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
        ui->verticalLayout_10->addWidget(chartView);
        // 将QChartView设置为父级QWidget的子控件，并调整大小和布局

}

MainWindow::~MainWindow()
{
    delete ui;
}

