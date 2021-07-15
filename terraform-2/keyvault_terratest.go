testpackage test

import (
    "testing"

    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

// An example of how to test the simple Terraform module in examples/basic using Terratest.
func TestTerraformBasicExample(t *testing.T) {

    // Test specific variables
    projectName := "automated0test"

    // Assertion variables
    expectedText := "testOutputName"

    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
        // The path to where our Terraform code is located
        TerraformDir: "../../examples/basic",

        // Variables to pass to our Terraform code using -var options
        Vars: map[string]interface{}{
            "project": projectName,
        },

        // Disable colors in Terraform commands so its easier to parse stdout/stderr
        NoColor: true,
    })

    // At the end of the test, run `terraform destroy` to clean up any resources that were created
    defer terraform.Destroy(t, terraformOptions)

    // This will run `terraform init` and `terraform apply` and fail the test if there are any errors
    terraform.InitAndApply(t, terraformOptions)

    // Run `terraform output` to get the values of output variables
    actualTextExample := terraform.Output(t, terraformOptions, "static_storage_account_name")

    // Verify we're getting back the outputs we expect
    assert.Equal(t, expectedText, actualTextExample)

}
