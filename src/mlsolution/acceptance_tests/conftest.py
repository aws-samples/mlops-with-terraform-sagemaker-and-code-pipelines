import pytest

def pytest_addoption(parser):
    parser.addoption(
        "--pipeline_name", 
        action="store", 
        default="", 
        help=""
    )


@pytest.fixture
def pipeline_name(request):
    return request.config.getoption("--pipeline_name")