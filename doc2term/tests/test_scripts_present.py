import subprocess

import pytest


@pytest.mark.parametrize(
	"command",
	["doc2term"],
)
def test_command_exists(command):
	try:
		proc = subprocess.run(
			[command], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
		)
		assert proc.returncode == 0
	except OSError as e:
		assert "" == e
