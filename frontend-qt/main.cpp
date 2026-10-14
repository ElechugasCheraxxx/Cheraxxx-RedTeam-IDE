#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "NativeBridge.hpp"

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Bridge to C++ Core
    NativeBridge bridge;
    engine.rootContext()->setContextProperty("bridge", &bridge);

    const QUrl url(u"qrc:/qt/qml/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
