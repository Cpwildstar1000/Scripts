#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QApplication>
#include <QPushButton>

int main(int argc, char *argv[]) {
    QApplicatoin app(argc, argv);

    QPushButton button("Test");
    button.show();

    return app.exec();
}