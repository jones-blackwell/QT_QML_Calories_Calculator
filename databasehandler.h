#ifndef DATABASEHANDLER_H
#define DATABASEHANDLER_H

#include <QObject>
#include <QtSql>
#include <QSqlDatabase>

class DatabaseHandler : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString calories READ calories WRITE setCalories NOTIFY caloriesChanged)
public:
    explicit DatabaseHandler(QObject *parent = nullptr);
    ~DatabaseHandler();
    Q_INVOKABLE bool insertData(QString, QString, QString, QString);
    Q_INVOKABLE QString calculateCalories(QString, QString, QString);
    QString calories();

private:

    QSqlDatabase database;
    QSqlQueryModel *queryModel;
    QString m_calories;

    float calculateProtein(QString);
    float calculateFat(QString);
    float calculateCarbohydrates(QString);

signals:
    void caloriesChanged();

public slots:
    void callMe();
    void setCalories(QString);

};

#endif // DATABASEHANDLER_H
