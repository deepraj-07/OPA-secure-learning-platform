# OPA Setup Guide

## Option 1: Using Docker (Recommended)

If you have Docker installed, you can run everything in containers:

```bash
docker-compose up -d
```

This will start:
- OPA policy server on `localhost:8181`
- Node.js app on `localhost:3000`

## Option 2: Using WSL or Linux

If you have Windows Subsystem for Linux (WSL), you can run OPA natively:

```bash
# On WSL (Ubuntu)
curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
chmod +x opa
./opa run --server --addr localhost:8181 policies/
```

## Option 3: Using Homebrew (macOS)

```bash
brew install opa
opa run --server --addr localhost:8181 policies/
```

## Option 4: Manual Executable Download

Download the OPA executable manually from:
- Windows: https://github.com/open-policy-agent/opa/releases/download/v0.61.0/opa_windows_amd64.exe
- Linux: https://github.com/open-policy-agent/opa/releases/download/v0.61.0/opa_linux_amd64
- macOS: https://github.com/open-policy-agent/opa/releases/download/v0.61.0/opa_darwin_amd64

Then place in the project root and run:

```bash
# Windows (PowerShell)
.\opa.exe run --server --addr localhost:8181 policies/

# Linux/macOS
./opa run --server --addr localhost:8181 policies/
```

## Verifying Setup

Once both OPA and the Node.js server are running, test with:

```bash
# Test endpoint (should fail without OPA running)
curl -X POST http://localhost:3000/course-access \
  -H "Content-Type: application/json" \
  -d '{"role":"student","action":"view","enrolled":true}'
```

Expected response when both are running:
```json
{"message":"Access Granted"}
```

## Troubleshooting

### OPA Server Not Responding
- Ensure OPA is running on `localhost:8181`
- Check: `curl http://localhost:8181/health`

### Express Server Won't Connect to OPA
- Verify OPA URL in middleware: `http://localhost:8181/v1/data/auth/allow`
- Check CORS if needed

### Policies Not Loading
- Verify `.rego` files are valid: `./opa test policies/ -v`
- Check policy syntax with: `./opa parse policies/`
