# Hotelling T2 tests
def hotelling_t2(X1, X2):
    n1, p = X1.shape
    n2, _ = X2.shape
    mean1 = X1.mean(axis=0)
    mean2 = X2.mean(axis=0)
    cov1 = X1.cov()
    cov2 = X2.cov()
    pooled_cov = ((n1 - 1) * cov1 + (n2 - 1) * cov2) / (n1 + n2 - 2)
    diff_mean = mean1 - mean2
    t2_stat = (n1 * n2) / (n1 + n2) * diff_mean.T @ np.linalg.inv(pooled_cov) @ diff_mean
    f_stat = (n1 + n2 - p - 1) / (p * (n1 + n2 - 2)) * t2_stat
    p_value = 1 - f.cdf(f_stat, p, n1 + n2 - p - 1)
    return t2_stat, p_value

def perform_hotelling_tests(X_train, X_val, X_test):
    t2_stat_val, p_val_val = hotelling_t2(X_train, X_val)
    t2_stat_test, p_val_test = hotelling_t2(X_train, X_test)
    print(f"Hotelling's T-squared test:")
    print(f"  Train vs Validation: T2-statistic = {t2_stat_val:.3f}, p-value = {p_val_val:.3f}")
    print(f"  Train vs Test: T2-statistic = {t2_stat_test:.3f}, p-value = {p_val_test:.3f}")
    
    alpha = 0.05
    if p_val_val < alpha:
        print("  Conclusion: The training and validation sets do not have the same mean (reject H0).")
    else:
        print("  Conclusion: The training and validation sets have the same mean (fail to reject H0).")
    
    if p_val_test < alpha:
        print("  Conclusion: The training and test sets do not have the same mean (reject H0).")
    else:
        print("  Conclusion: The training and test sets have the same mean (fail to reject H0).")

perform_hotelling_tests(X_train, X_val, X_test)