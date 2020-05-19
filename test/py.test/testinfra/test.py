import os
import pytest

sdkman_user = 'ubuntu'


def script_wrap(host, cmds, as_interactive=True):
    # if running as interactive shell, .bashrc will be sourced
    wrapped_cmd = "/bin/bash {0} -c '{1}'".format(
        '-i' if as_interactive else '',
        '; '.join(cmds)
    )

    if host.user.name == sdkman_user:
        return wrapped_cmd
    else:
        return "sudo -H -u {0} {1}".format(sdkman_user, wrapped_cmd)


def check_run_for_rc_and_result(cmds, expected, host, check_stderr=False,
                                as_interactive=True):
    result = host.run(script_wrap(host, cmds, as_interactive))
    assert result.rc == 0
    if check_stderr:
        assert result.stderr.find(expected) != -1
    else:
        assert result.stdout.find(expected) != -1


@pytest.mark.base
def test_os_release(host):
    release = host.file("/etc/os-release")
    assert release.contains("ubuntu")
    assert release.contains("bionic")
    assert release.contains("18.04")


@pytest.mark.base
def test_passwd_file(host):
    passwd = host.file("/etc/passwd")
    assert passwd.contains("root")
    assert passwd.user == "root"
    assert passwd.group == "root"
    assert passwd.mode == 0o644


@pytest.mark.base
def test_hostname(host):
    vm_name = os.getenv("VM_NAME")
    hostname = host.file("/etc/hostname")
    assert hostname.contains(vm_name)


@pytest.mark.base
@pytest.mark.parametrize("name,version", [
    ("wget", "1.19."),
    ("git", "1:2."),
])
def test_packages(host, name, version):
    pkg = host.package(name)
    assert pkg.is_installed
    assert pkg.version.startswith(version)


@pytest.mark.base
@pytest.mark.parametrize("name,tcp_socket", [
    ("sshd", "tcp://0.0.0.0:22"),
])
def test_service_running_enabled_and_listening(host, name, tcp_socket):
    service = host.service(name)
    assert service.is_running
    assert service.is_enabled
    socket = host.socket(tcp_socket)
    assert socket.is_listening


@pytest.mark.base
def test_internet_connection(host):
    cisco = host.addr("developer.cisco.com")
    assert cisco.is_resolvable
    assert cisco.is_reachable
    assert cisco.port(443).is_reachable


@pytest.mark.postcondition
def test_config_file_for_sdkman(host):
    result = host.run(script_wrap(host, ['echo $SDKMAN_DIR']))
    config_file_path = "{0}/etc/config".format(result.stdout.rstrip())

    f = host.file(config_file_path)
    assert f.exists
    assert f.is_file
    assert f.user == sdkman_user
    assert f.contains('sdkman_auto_answer=true')


@pytest.mark.postcondition
def test_java_installed(host):
    cmds = ['java --version']
    expected = 'OpenJDK'
    check_run_for_rc_and_result(cmds, expected, host)


@pytest.mark.postcondition
def test_sdk_installed(host):
    cmds = ['sdk version']
    expected = 'SDKMAN'
    check_run_for_rc_and_result(cmds, expected, host)


# @pytest.mark.postcondition
# @pytest.mark.parametrize("name,tcp_socket", [
#     ("mysqld", "tcp://0.0.0.0:3306"),
# ])
# def test_service_running_enabled_and_listening(host, name, tcp_socket):
#     service = host.service(name)
#     assert service.is_running
#     assert service.is_enabled
#     socket = host.socket(tcp_socket)
#     assert socket.is_listening


# @pytest.mark.parametrize("mount_point", [
#     "/bizapps",
#     "/tools",
#     "/vagrant",
# ])
# def test_mount_points(host, mount_point):
#     mount = host.mount_point(mount_point)
#     assert mount.exists
