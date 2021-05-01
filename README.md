# Nebula VPN Helm Chart

This chart deploys [Nebula](https://github.com/slackhq/nebula) on Kubernetes nodes as a DaemonSet.
This can allow a private cluster to be reachable by users, or can allow the Kube Api Server to talk to normally
unroutable Kubelets.

## Development status and notes

- This currently does not deploy lighthouses
- All cert mangement must be done out of band

## Requirements

- [Helm](https://helm.sh/) 3
- Kubernetes 1.18+

## Deploying

```bash
helm install --create-namespace --namespace nebula-system nebula chart/nebula
```

## Configuration

The initial configuration does not setup any nodes. You will need to
configure your node CA certs, private keys and public keys.

To do this, create a `values-override.yaml` and configure the following:

### Lighthouse Configuration

Add the following sections to your config file.

```yaml
# Lighthouse IP to public IPs
staticHostMap:
  192.168.200.1: ["henry.dev:4242"]

ca:
  public: |
    -----BEGIN NEBULA CERTIFICATE-----
    YOUR NEBULA CA PUBLIC KEY HERE
    -----END NEBULA CERTIFICATE-----
```

### Node configuration

For each Kubelet you wish to add to the cluster, you will need to create a keypair
and set that in your configuration file.

```yaml
nodes:
  - name: worker-1
    public: |
      -----BEGIN NEBULA CERTIFICATE-----
      YOUR CLIENT PUBLIC KEY HERE
      -----END NEBULA CERTIFICATE-----
    private: |
      -----BEGIN NEBULA X25519 PRIVATE KEY-----
      YOUR CLIENT PUBLIC KEY HERE
      -----END NEBULA X25519 PRIVATE KEY-----
```

### Updating configuration

Each time you update the configuration file, you will need to upgrade your chart release.

```bash
helm upgrade --namespace nebula-system nebula -f values-override.yaml chart/nebula
```
