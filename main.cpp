#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtQml/QQmlContext>
#include <QtCore/QDebug>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //get video/audio source URL from application "-url file:///home/root..." argument
    QUrl source;
    QStringList args = app.arguments();
    bool sourceIsUrl = false;
    for (int i = 1; i < args.size(); ++i) {
            const QByteArray arg = args.at(i).toUtf8();
            if (arg.startsWith('-')) {
                if ("-url" == arg) {
                    sourceIsUrl = true;
                } else {
                    qDebug() << "Option" << arg << "ignored";
                }
            } else {
                if ((sourceIsUrl == true) && arg.startsWith("file:///") )
                    source = arg;
                else
                    qDebug() << "Argument ignored! Please use \"-url file:///home/root/...\"";
            }
        }

    qDebug() << source;
    /*
    QUrl url;
    if (sourceIsUrl) {
        url = source;
    }

    qDebug() << url; */

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("mysource", source);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
