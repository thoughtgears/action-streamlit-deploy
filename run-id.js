module.exports = async ({github, context, core}) => {
    // const path = require('path');
    // const workflow = context.workflow;
    // const workflow_id = path.basename(workflow);

    const resp = await github.rest.actions.listWorkflowRuns({
        owner: context.repo.owner,
        repo: context.repo.repo,
        workflow_id: context.workflow,
        status: 'success',
        per_page: '1'
    });
    console.log(resp.data.workflow_runs[0].id);
    core.exportVariable('job_id', resp.data.workflow_runs[0].id)
}