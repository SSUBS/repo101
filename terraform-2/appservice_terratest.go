package tests

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

func TestAppServiceBuild(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options {
		TerraformDir:             "./fixture_simple",
	}

	terraform.InitAndApply(t, terraformOptions)
	defer terraform.Destroy(t, terraformOptions)

	testAppServiceEndpoint(t, terraformOptions, "hostname")
}

func testAppServiceEndpoint (t *testing.T, terraformOptions *terraform.Options, hostname string)  {
	maxRetries := 5
	timeBetweenRetries := 5 * time.Second

	host := terraform.Output(t, terraformOptions, hostname)
	description := fmt.Sprintf("HTTP request to %s", host)

	expectedCode := 200

	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualCode, _ := http_helper.HttpGet(t, host, nil)

		if actualCode != expectedCode {
			return "", fmt.Errorf("expect HTTP code %d but got %d", expectedCode, actualCode)
		}
		fmt.Println(actualCode)

		return "", nil
	})
}
