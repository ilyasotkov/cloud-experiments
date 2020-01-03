import requests
import logging
import pytest

def test_main(catalog_table):
    pass

@pytest.fixture
def catalog_table():
    WEBHCAT = "http://webhcat:50111/templeton/v1"
    db_name = "mydb1"
    try:
        response = requests.put(f"{WEBHCAT}/ddl/database/{db_name}?user.name=ilya",
            json={
                "comment": "Hello there",
                "location": f"s3a://mybucket/{db_name}",
                "properties": {"a":"b"}
            }
        )
        response.raise_for_status()
    except requests.exceptions.HTTPError as e:
        if e.response.status_code == 409:
            logging.warning(response.json())

    try:
        table_name = "mytable2"
        response = requests.put(f"{WEBHCAT}/ddl/database/{db_name}/table/{table_name}?user.name=ilya",
            json={
                "location": "s3a://mybucket/mydata/",
                "comment": "Best table made today",
                "external": True,
                "ifNotExists": True,
                "tableProperties": {
                    "skip.header.line.count": "1"
                },
                "columns": [
                    { "name": "id", "type": "string" },
                    { "name": "fn", "type": "string" },
                    { "name": "ln", "type": "string" }
                ],
                "format": {
                    "storedAs": "TEXTFILE",
                    "rowFormat": {
                        "fieldsTerminatedBy": ",",
                        "serde": {
                            "name": "org.apache.hadoop.hive.serde2.OpenCSVSerde",
                            "properties": {
                                "separatorChar": ","
                            },
                        },
                    },
                    # "storedBy": "",
                },
            }
        )
        response.raise_for_status()
    except Exception as e:
        logging.error(e)
        raise e
