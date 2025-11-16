from testcontainers.core.container import DockerContainer
from testcontainers.core.wait_strategies import LogMessageWaitStrategy, HealthcheckWaitStrategy
import requests

checkip_url = 'http://checkip.amazonaws.com'

def test_anonymization(img_name):
    regular_ip = requests.get(checkip_url).text.strip()
    with DockerContainer(img_name).with_kwargs(privileged=True).waiting_for(LogMessageWaitStrategy(".*Tor ist ready.*")).with_command(f"sleep 60") as subject:
        result = subject.exec(f"wget -q -O - -T 60 {checkip_url}")
        assert result.exit_code == 0
        actual_ip = result.output.decode('utf-8').strip()
        assert regular_ip != actual_ip

def test_healthcheck(img_name):
    with DockerContainer(img_name).with_kwargs(privileged=True).waiting_for(HealthcheckWaitStrategy()).with_command(f"sleep 130") as subject:
        result = subject.exec(f"wget -q -O - -T 60 {checkip_url}")
        assert result.exit_code == 0