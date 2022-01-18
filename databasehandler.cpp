#include "databasehandler.h"
#include <QDebug>

DatabaseHandler::DatabaseHandler(QObject *parent) : QObject(parent)
{
    m_calories = "";

    database =  QSqlDatabase::addDatabase("QMYSQL");
    database.setHostName("127.0.0.1");
    database.setUserName("root");
    database.setPassword("");
    database.setDatabaseName("food_calories_db");
    database.open();

    QString sql = "CREATE TABLE IF NOT EXISTS `nutrients` ( "
                  "`id` INT NOT NULL AUTO_INCREMENT ,  "
                  "`food`  VARCHAR(100) NOT NULL ,  "
                  "`fat` FLOAT NOT NULL ,  "
                  "`proten` FLOAT NOT NULL ,  "
                  "`cabohydrates` FLOAT NOT NULL ,  "
                  "`date_added` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,    "
                  "PRIMARY KEY  (`id`),    UNIQUE  `fat_index` (`food`)"
                  ") ENGINE = InnoDB;";

    QSqlQuery qry;
    qry.prepare(sql);
    if( !qry.exec() )
        qDebug() << qry.lastError();
    else
        qDebug() << "Nutrients table created!";
}

DatabaseHandler::~DatabaseHandler() {
    database.close();
}

bool DatabaseHandler::insertData(QString food, QString fat, QString carbohydrates, QString protein)
{
    if (database.isOpen()) {
        queryModel = new QSqlQueryModel();
        queryModel->setQuery("SELECT * FROM `nutrients`");

        QString v = "hello";
        QString v2 = "world";


        qDebug() << QString("Connected %1 %2").arg(v).arg(v2);

        QString insertSQL = QString("INSERT INTO `nutrients` "
                            "(`id`, `food`, `fat`, `proten`, `cabohydrates`, `date_added`) "
                            "VALUES (NULL, '%1', '%2', '%3', '%4', current_timestamp());")
                            .arg(food).arg(calculateFat(fat)).arg(calculateProtein(protein))
                            .arg(calculateCarbohydrates(carbohydrates));

        QSqlQuery query(database);
        bool insert = query.exec(insertSQL);
        if(!insert){
            qDebug() << "Failed to insert Data!" ;
        }else{
            qDebug() << "Database operation successful!" ;

            return true;
        }

    } else {
        qDebug() << "Not Connected ";
    }

    return false;
}

QString DatabaseHandler::calories()
{
    return m_calories;
}

float DatabaseHandler::calculateCarbohydrates(QString carbohydrates)
{
    float c = (carbohydrates.toFloat()) * 9;
    return c;
}

float DatabaseHandler::calculateFat(QString fat)
{
    float c = (fat.toFloat()) * 4;
    return c;
}

float DatabaseHandler::calculateProtein(QString protein)
{
    float c = (protein.toFloat()) * 4;
    return c;
}

void DatabaseHandler::callMe()
{
    qDebug()<< "I'm being Called";
}

void DatabaseHandler::setCalories(QString calories)
{
    m_calories = calories;
    emit caloriesChanged();
}

QString DatabaseHandler::calculateCalories(QString fat, QString carbohydrates, QString protein)
{
    float totalCalories = calculateCarbohydrates(carbohydrates)+calculateFat(fat)+calculateProtein(protein);

    return QString("%1").arg(totalCalories);
//    emit caloriesChanged();
}
