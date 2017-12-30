import Elm from '../Voting'

document.addEventListener('DOMContentLoaded', () => {
    const target = document.querySelector('#voting')
    const celebrityId = parseInt(target.dataset.celebrityId)
    Elm.Main.embed(target, {celebrity_id: celebrityId})
})
