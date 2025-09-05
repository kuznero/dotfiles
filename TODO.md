<!-- markdownlint-disable MD047 -->

# Dotfiles Improvement TODO

- [ ] Configure Podman instead of Docker (ref: https://nixos.wiki/wiki/Podman)

## High Priority

### 🏗️ Structure & Organization

- [ ] **Modularize flake.nix** - Split into separate files (hosts/, home/, overlays/)
  - Extract host-specific configurations to dedicated modules
  - Create shared configuration imports to reduce duplication
  - Consider using flake-parts or similar for better organization

- [ ] **Create shared module system**
  - Extract common host configurations (docker, fonts, etc.) into reusable modules
  - Implement proper module options with types and defaults
  - Reduce duplication between moon/sun/wsl configurations

- [ ] **Standardize configuration patterns**
  - Unify parameterization approach across all modules
  - Create consistent naming conventions for options and modules
  - Establish clear separation between host-specific and user-specific configs

### ⚡ Performance & Efficiency

- [ ] **Optimize package management**
  - Audit and remove unused packages from common.nix:1-59
  - Create package collections by category (dev-tools, media, etc.)
  - Consider using overlays for package customization

- [ ] **Reduce font bloat**
  - Review nerd-fonts collection in common.nix:27-42
  - Keep only actively used fonts (likely mononoki, jetbrains-mono, iosevka)
  - Create font profiles for different use cases

- [ ] **Optimize nixvim configuration**
  - Review nixvim.nix:1-1169 for unused plugins and excessive configuration
  - Consider lazy-loading for plugins
  - Profile startup time and optimize bottlenecks

## Medium Priority

### 🔒 Security & Maintenance

- [ ] **Externalize sensitive data**
  - Move SSH signing key from git.nix:37-38 to external secret management
  - Consider using agenix or sops-nix for secrets
  - Review all hardcoded keys/tokens in configurations

- [ ] **Improve version management**
  - Pin versions for custom packages in pkgs/
  - Add update automation or documentation
  - Consider using flake inputs for version management

- [ ] **Add configuration validation**
  - Implement module type checking and validation
  - Add pre-commit hooks for Nix formatting and validation
  - Create CI/CD pipeline for configuration testing

### 📚 Documentation & Maintenance

- [ ] **Create comprehensive documentation**
  - Document custom modules and their options
  - Add architecture decision records (ADRs)
  - Create troubleshooting guides for common issues

- [ ] **Improve corporate environment support**
  - Extract corporate proxy/certificate logic from README.md:60-89
  - Create dedicated corporate environment module
  - Add environment-specific configuration switching

- [ ] **Enhance development workflow**
  - Add more sophisticated Taskfile.yaml commands
  - Create development shell with required tools
  - Add configuration deployment automation

## Low Priority

### 🧹 Code Quality

- [ ] **Code cleanup and consistency**
  - Remove commented code blocks (flake.nix:276-306)
  - Standardize attribute ordering in configurations
  - Add consistent commenting and documentation

- [ ] **Testing and validation**
  - Add integration tests for different host configurations
  - Create smoke tests for critical functionality
  - Implement configuration diff tools

### 🔧 Feature Enhancements

- [ ] **Add configuration profiles**
  - Create minimal/full installation profiles
  - Add work/personal environment switching
  - Implement feature flags for optional components

- [ ] **Improve cross-platform support**
  - Better macOS/Linux configuration sharing
  - Platform-specific optimizations
  - Consistent behavior across different architectures

---

## Notes

- Priority levels indicate order of implementation
- Some items may have dependencies on others
- Consider impact on daily workflow when making changes
- Test changes in isolated environments before applying to main systems
